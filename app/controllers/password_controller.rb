class PasswordController < ApplicationController
  PASSWORD_RESET_SUCCESSFUL = "Your password has been successfully reset."

  USER_NOT_FOUND = %{ Sorry, your reset link has expired.
    Please generate a new one.}.squish

  def edit
    unless @member = Member.find_by_code( params[:code] )
      flash[:form_type] = "reset"
      redirect_to root_url, notice: USER_NOT_FOUND
    end
    @nologin = true
  end

  def update
    if @member = Member.find_by_code( params[:code] )
      resetter = PasswordResetter.new(flash)

      if resetter.update_password( @member, member_params )
        flash[:notice] = PASSWORD_RESET_SUCCESSFUL
        log_in_and_redirect( @member )
      else
        flash[:error] = @member.errors
        render :edit
      end
    else
      flash[:form_type] = "reset"
      redirect_to root_url, error: USER_NOT_FOUND
    end
  end

  private

  def member_params
    params.require(:member).permit( :password, :password_confirmation )
  end
end
