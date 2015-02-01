require 'the_role_api/hash'
require 'the_role_api/config'
require 'the_role_api/version'

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

    initializer "the_role_precompile_hook", group: :all do |app|
      app.config.assets.precompile += %w(
        the_role_management_panel.js
        the_role_management_panel.css
      )
    end
  end
end

# ==========================================================================================
# Just info
# ==========================================================================================
#
# http://stackoverflow.com/questions/6279325/adding-to-rails-autoload-path-from-gem
# config.to_prepare do; end
#
# ==========================================================================================
#
# require 'the_role_api/active_record'
#
# if defined?(ActiveRecord::Base)
#   ActiveRecord::Base.extend TheRole::Api::ActiveRecord
# end
#
# ==========================================================================================
