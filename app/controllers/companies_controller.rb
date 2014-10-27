class CompaniesController < ApplicationController
  before_action :is_authenticated?
  before_action :get_company, except: [ :index, :show ]

  def index
    @companies = Company.order( name: :asc ).vetted.entries
  end

  def show
    redirect_to root_url, error: "Company not found" unless @company = Company.vetted.find_by( slug: params[:id] )
  end
end
