class EmailController < ApplicationController

  def update
    if @job = Job.find_by_code( params[:code] )
      @job.verify

      JobMailer.email_is_verified(@job).deliver

      redirect_to company_job_url(@job.company, @job),\
        notice: "Contact email for #{@job.title} is verified and job is public!"
    else
      redirect_to root_url,\
        error: "Can't find that job listing! Perhaps you already validated it?"
    end
  end
end
