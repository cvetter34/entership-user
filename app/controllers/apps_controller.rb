class AppsController < ApplicationController
  before_action :is_authenticated?
  before_action :get_job, except: [ :index ]
  before_action :get_app, except: [ :index, :new, :create ]

  def index
    @apps = @current_member.apps.order( status: :desc )
  end

  def show
  end

  def new
    @app = App.new({
      member: @current_member,
      name_given: @current_member.name_given,
      name_family: @current_member.name_family,
      age: @current_member.age,
      nationality_code: @current_member.nationality_code,
      country_code: @current_member.country_code,
      phone: @current_member.phone,
      email: @current_member.email
    })
  end

  def create

    @app = @job.apps.new( app_params )
    @app.member = @current_member

    if @app.save
      AppNotifier.send_application_notification(@app).deliver
      
      redirect_to jobs_url, notice: "Successfully applied to #{@job.title}."
    else
      render :new, error: "Can't create the application."
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @app.destroy

    redirect_to apps_url
  end

  private

  def get_job
    @job = Job.find_by id: params[:job_id]

    redirect_to apps_url, error: "Cant' find that job listing." unless @job
  end

  def get_app
    @app = @job.apps.find_by( id: params[:id] )

    redirect_to root_url, error: "Can't find that app." unless @app
  end

  def app_params
    params.require(:app).permit(
      :name_given,
      :name_family,
      :age,
      :nationality_code,
      :country_code,
      :phone,
      :email,
      :comments,
      :has_right_to_work,
      :has_work_permit,
      :work_permit_detail,
      :cv,
      :cv_cache,
      :doc_one,
      :doc_one_cache,
      :doc_two,
      :doc_two_cache,
      :doc_three,
      :doc_three_cache,
      :doc_four,
      :doc_four_cache
    )
  end
end
