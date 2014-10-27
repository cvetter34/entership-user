class MemberAuthenticator

  def self.messages
    {
      auth_failed: %{
        Unable to log you in.
        Please check your email and password and try again.
      }.squish
    }
  end

  def initialize(flash)
    @flash = flash
  end

  def authenticate(member_params)
    unless member = Member.authenticate(
        member_params[:email].downcase,
        member_params[:password]
      )

      @flash[:error] = MemberAuthenticator.messages[:auth_failed]
    end

    member
  end
end
