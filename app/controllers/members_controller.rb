class MembersController < ApplicationController
  before_action :is_authenticated?

  def index
    @members = Member.where( is_public: true )
  end

  def show
    redirect_to members_url unless @member = Member.where( slug: params[:id], is_public: true ).first
  end
end
