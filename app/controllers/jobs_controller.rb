class JobsController < ApplicationController
  before_action :is_authenticated?
  before_action :get_company
  before_action :is_members_company?, except: [ :index, :show ]
  before_action :get_job, except: [ :index, :new, :create ]

  def index
    @jobs = if @company
      @company.jobs
    else
      Job.active
    end

    @jobs = @jobs.order( created_at: :desc ).map do |job|
      job.mine = @jobs_applied_to.include?(job)
      job
    end.sort {|x,y| x <=> y }
  end

  def show
    @app = App.find_by( job: @job, member: @current_member )
    puts "@app >>>>>>", @app.inspect
  end

  private

  def get_company
    @company = Company.vetted.find_by( slug: params[:company_id] ) if params[:company_id]
  end

  def get_job
    @job = if @company
      @company.jobs.find_by( id: params[:id] )
    else
      Job.active.find_by( id: params[:id] )
    end

    redirect_to jobs_url unless @job
  end
end
