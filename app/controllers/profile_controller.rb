class ProfileController < ApplicationController
  before_action :is_authenticated?

  def show
  end

  def update
    if @current_member.update_attributes( member_params )
      redirect_to profile_url, notice: "Your profile has been updated."
    else
      render "show", error: @current_member.errors
    end
  end

  def destroy
    # @current_member.update_attributes( deleted_at: Time.now )
    @current_member.destroy

    if request.xhr?
      head :ok
    else
      log_member_out_and_redirect
    end
  end

  private

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
