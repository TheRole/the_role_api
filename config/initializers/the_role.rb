# TheRole.config.param_name => value

TheRole.configure do |config|
  # [ Devise => :authenticate_user! | Sorcery => :require_login ]
  # config.login_required_method = :authenticate_user!

  # config.default_user_role          = nil
  # config.first_user_should_be_admin = false

  # config.access_denied_method       = :access_denied
  # config.destroy_strategy           = :restrict_with_exception # can be nil
  # config.layout                     = :application             # layout for Management panel
end
