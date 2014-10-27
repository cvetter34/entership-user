class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_member

  before_action :detect_device_format, :set_attributes
  before_filter :make_action_mailer_use_request_host_and_protocol

  def current_member
    @current_member ||= Member.find_by( id: session[:member_id] )
  end

  def is_authenticated?
    unless current_member
      session[:redirect_to] = request.fullpath
      redirect_to root_url
    end
  end

  def hide
    redirect_to request.referer || root_url
  end

  def log_in_and_redirect(member)
    session[:member_id] = member.id

    default_path = member.has_pending_apps? ? root_url : jobs_url

    path = session[:redirect_to] || default_path
    session[:redirect_to] = nil

    redirect_to path
  end

  def log_member_out_and_redirect
    session[:member_id] = nil
    redirect_to root_url, notice: "You've successfully logged out."
  end

  def set_attributes
    if current_member
      set_jobs_applied_to       # Get the jobs applied to for jobs page
      set_pending_apps          # Get the pending apps for navbar
    end
  end

  def set_jobs_applied_to
    @jobs_applied_to = @current_member.apps.map do |app|
      app.job
    end
  end

  def set_pending_apps
    @pending_apps = @current_member.apps.select do |app|
      app.status == App.ok_statuses[:pending]
    end
  end

  private

  def detect_device_format
    if browser.tablet?
      request.variant = :tablet
    elsif browser.mobile?
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end

  def make_action_mailer_use_request_host_and_protocol
    ActionMailer::Base.default_url_options[:protocol] = request.protocol
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end
end
