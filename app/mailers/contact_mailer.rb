require 'kramdown'

class ContactMailer < ActionMailer::Base
  default from: "EnterShip <info@entership.net>"

  def contact(contact)
    @contact = contact
    @member = contact.member
    @body = Kramdown::Document.new(contact.body).to_html.html_safe

    headers["X-Member-ID"] = @member.id

    mail to: @member.email, subject: "[EnterShip] #{contact.subject}"
  end

  def contact_autoreply(contact)
    @contact = contact
    @member = contact.member
    @body = Kramdown::Document.new(contact.body).to_html.html_safe

    headers["X-Member-ID"] = @member.id

    mail to: @member.email, subject: "[EnterShip] wrt #{contact.subject}"
  end
end
