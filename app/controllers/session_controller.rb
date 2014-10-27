class SessionController < ApplicationController

  def new
    redirect_to root_url, notice: "You are logged in." if current_member
    @nologin = true
    @form_type = "login"
  end

  def create
    case params[:form]
    when "login"
      if member = MemberAuthenticator.new(flash).authenticate(member_params)
        return if log_in_and_redirect( member )
      end
    when "reset"
      PasswordResetter.new(flash).set_password_reset_code_and_notify_member(member_params[:email])
    when "register"
      MemberRegisterer.new(flash).create_a_new_registrant(member_params[:email])
    else
      flash[:error] = "There was a problem with the form. Please check your inputs and try again."
    end

    flash[:email] = member_params[:email]

    redirect_to root_url
  end

  def destroy
    log_member_out_and_redirect
  end

  private

  def member_params
    params.require(:member).permit( :email, :password )
  end
end
