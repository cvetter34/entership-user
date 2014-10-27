class MemberNotifier < ActionMailer::Base
  default from: "EnterShip <info@entership.net>"

  CODED_RESET_LINK          = "[EnterShip] Reset your credentials"
  PASSWORD_WAS_RESET        = "[EnterShip] Your password has been reset!"
  CODED_REGISTRATION_LINK   = "[EnterShip] Complete your registration"
  WELCOME_NEW_USER          = "[EnterShip] Welcome to EnterShip!"

  def coded_password_reset_link(member)
    @member = member

    headers["X-Member-ID"] = @member.id

    mail to: @member.email, subject: CODED_RESET_LINK
  end

  def password_was_reset(member)
    @member = member

    headers["X-Member-ID"] = @member.id

    mail to: @member.email, subject: PASSWORD_WAS_RESET
  end

  def coded_registration_link(registrant)
    @registrant = registrant

    headers["X-Registrant-ID"] = @registrant.id

    mail to: @registrant.email, subject: CODED_REGISTRATION_LINK
  end

  def welcome(member)
    @member = member

    headers["X-Member-ID"] = @member.id

    mail to: @member.email, subject: WELCOME_NEW_USER
  end
end
