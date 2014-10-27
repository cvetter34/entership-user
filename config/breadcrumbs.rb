crumb :root do
  link "Home", root_url
end

crumb :companies do
  link "Companies", companies_url
end

crumb :company do |company|
  link company.name, company_url(company)
  parent :companies
end

crumb :jobs do
  link "Jobs", jobs_url
end

crumb :job do |job|
  link "#{job.title} at #{job.company.name}", job_url(job)
  parent :jobs
end

crumb :apps do
  link "Job applications", apps_url
end

crumb :app do |app|
  link app.name, job_app_url(app.job, app)
  parent :apps
end

crumb :job_app_new do |job|
  link "Apply", new_job_app_url(job)
  parent :job, job
end

crumb :app_edit do |app|
  link "Edit application", edit_app_url(app)
  parent :app, app
end

crumb :profile do |member|
  link member.name_given, profile_url
end

crumb :profile_edit do |member|
  link "Edit profile", edit_profile_url
  parent :profile, member
end
