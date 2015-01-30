require 'the_role_api/hash'
require 'the_role_api/config'
require 'the_role_api/version'
require 'the_role_api/activerecord'

require 'multi_json'
require 'the_string_to_slug'

module TheRole
  class << self
    def create_admin!
      admin_role = ::Role.where(name: :admin).first_or_create!(
          name:        :admin,
          title:       "Role for admin",
          description: "This user can do anything"
      )
      admin_role.create_rule(:system, :administrator)
      admin_role.rule_on(:system, :administrator)
      admin_role
    end
  end

  class Engine < Rails::Engine
    config.autoload_paths << "#{ config.root }/app/models/concerns/**"
    config.autoload_paths << "#{ config.root }/app/controllers/concerns/**"
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend TheRole::Api::ActiveRecord
end

# ==========================================================================================
# Just info
# ==========================================================================================
#
# initializer "TheRole precompile hook", group: :all do |app|
#   app.config.assets.precompile += %w( x.js y.css )
# end
#
# http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
# config.to_prepare do; end
