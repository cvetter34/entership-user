class AppNotifier < ActionMailer::Base
  default from: "EnterShip <info@entership.net>"

  CODED_REDIRECT_LINK          = "[EnterShip] New application received"

  def send_application_notification(app)
    @app = app

    # TODO: Change this to the correct URL for the company.entership.net site.
    @url = "http://localhost:3001/apps/redirect/#{@app.link_code}"

    headers["X-App-ID"] = @app.id

    mail to: @app.member.email, subject: CODED_REDIRECT_LINK
  end
end
