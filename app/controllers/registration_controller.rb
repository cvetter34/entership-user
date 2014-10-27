class RegistrationController < ApplicationController
  before_action :get_registrant

  REGISTRANT_NOT_FOUND = %{
    Registration code not found or expired.
    Please try again.
  }.squish

  def new
    @member = Member.new email: @registrant.email
    @nologin = true
  end

  def create
    if @registrant.is_company
      if @company = MemberRegisterer.new(flash).create_new_company_from_registrant(
          @registrant, company_params
        )

        log_in_and_redirect( @company )
      else
        flash[:error] = @company.errors
        render :new
      end
    else
      if @member = MemberRegisterer.new(flash).create_new_member_from_registrant(
          @registrant, member_params
        )

        log_in_and_redirect( @member )
      else
        flash[:error] = @member.errors
        render :new
      end
    end
  end

  private

  def get_registrant
    unless @registrant = Registrant.find_by_code( params[:code] )
      flash[:form_type] = "register"
      redirect_to root_url, error: REGISTRANT_NOT_FOUND
    end
  end

  def member_params
    params.require(:member).permit(
      :title,
      :name_given,
      :name_family,
      :born_on,
      :hide_born_on,
      :nationality_code,
      :country_code,
      :street_address,
      :city,
      :postal_code,
      :occupation,
      :phone,
      :mobile,
      :website_url,
      :notice,
      :will_relocate,
      :current_status,
      :hide_status,
      :experience,
      :is_public,
      :photo,
      :photo_cache,
      :sectors => []
    )
  end
end
