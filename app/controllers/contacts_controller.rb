class ContactsController < ApplicationController
  before_action :is_authenticated?, only: [ :create ]

  def new
    if @current_member
      @contact = Contact.new
      @contact.member = @current_member
    end
  end

  def create
    if @contact = Contact.create( contact_params )
      ContactMailer.contact(@contact).deliver
      ContactMailer.contact_autoreply(@contact).deliver

      redirect_to contact_us_url, notice: "Your message has been sent."
    else
      flash[:error] = "There was a problem sending your message. Please check your form and try again."
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit( :subject, :body ).merge( member_id: @current_member.id )
  end
end
