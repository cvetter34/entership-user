class MemberRegisterer

  def self.messages
    {
      success: %{ We sent you an email with instructions for
        completing your registration.}.squish,
      welcome: %{
        You have successfully completed your EnterShip registration and
        are logged in. Welcome to EnterShip!
      }.squish,
      already_registered: "You are already registered. Reset your password?",
      mail_failed: "Unable to send email. Please notify the webmaster.",
      save_failed: "Registration failed. Please notify the webmaster."
    }
  end

  def initialize(flash)
    @flash = flash
  end

  def create_a_new_registrant(email)
    if Member.find_by( email: email )
      @flash[:error] = MemberRegisterer.messages[:already_registered]
      @flash[:form_type] = "reset"
    else
      @registrant = Registrant.find_or_initialize_by(
        email: email, is_company: false
      )

      if @registrant.save
        send_sign_up_coded_link
      else
        @flash[:error] = MemberRegisterer.messages[:save_failed]
      end
    end
  end

  def create_new_member_from_registrant(registrant, member_params)
    params = member_params.merge( email: registrant.email )

    if member = Member.create( params )
      registrant.destroy
      send_welcome_email(member)

      @flash[:notice] = MemberRegisterer.messages[:welcome]
    end

    member
  end

  private

  def send_sign_up_coded_link
    begin
      MemberNotifier.coded_registration_link(@registrant).deliver

      @flash[:notice] = MemberRegisterer.messages[:success]
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      @flash[:error] = MemberRegisterer.messages[:mail_failed]
    end
  end

  def send_welcome_email(member)
    begin
      MemberNotifier.welcome(member).deliver
    rescue Exception => e
      puts e.message
      puts e.backtrace.inspect
      # Fail silently
    end
  end
end
