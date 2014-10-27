class SiteController < ApplicationController
  before_action :is_authenticated?, only: [ :education ]

  def index
    if current_member
      @apps = App.where( member_id: @current_member.id ).order( status: :asc )
    else
      @email = flash[:email]
      @form_type = flash[:form_type] || 'login'
      @is_company = flash[:is_member]

      @nologin = true
    end
  end

  def education
    begin
      if @education  = YAML.load_file("../data/education.yml")
        @courses = @education["courses"] || []
        @seminars = @education["seminars"] || []
      end
    rescue
    end
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def terms
  end

  def cookies
  end
end
