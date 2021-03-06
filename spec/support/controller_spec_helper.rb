module ControllerSpecHelper
  def login_as_api_user(user = User.new)
    request.env['warden'] = double("Authenticated API User",
      authenticate!: true,
      authenticated?: true,
      user: user
    )
  end
end
