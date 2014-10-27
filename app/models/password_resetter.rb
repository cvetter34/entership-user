class PasswordResetter

  def self.messages
    {
      success: %{ We sent you an email with instructions for
        resetting your password.}.squish,
      member_not_found: "No such member. Did you wish to sign up instead?",
      mail_failed: "Unable to send email. Please notify the webmaster.",
      save_failed: "Password reset failed. Please notify the webmaster."
    }
  end

  def initialize(flash)
    @flash = flash
  end

  def set_password_reset_code_and_notify_member(email)
    @member = Member.find_by( email: email )

    if !@member
      @flash[:error] = PasswordResetter.messages[:member_not_found]
      @flash[:form_type] = "register"
    elsif @member.set_password_reset_code
      send_password_reset_coded_link
    else
      @flash[:error] = PasswordResetter.messages[:save_failed]
    end
  end

  def update_password(member, member_params)
    if member.reset_password( member_params )
      begin
        MemberNotifier.password_was_reset( member ).deliver
      rescue
        @flash[:error] = PasswordResetter.messages[:mail_failed]
      end

      return true
    end
  end

  private

  def send_password_reset_coded_link
    begin
      MemberNotifier.coded_password_reset_link(@member).deliver

      @flash[:notice] = PasswordResetter.messages[:success]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      @flash[:error] = PasswordResetter.messages[:mail_failed]
    end
  end
end
