class TheRoleGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../../../../', __FILE__)
  # argument :xname, type: :string, default: :xname

  def generate_controllers
    if gen_name == 'install'
      cp_config
      cp_models
    elsif gen_name == 'config'
      cp_config
    elsif gen_name == 'models'
      cp_models
    elsif gen_name == 'admin'
      create_admin_role
    else
      puts 'TheRole Generator - wrong Name'
      puts 'Try to use install'
    end
  end

  private

  def root_path; TheRole::Engine.root; end

  def gen_name
    name.to_s.downcase
  end

  def cp_models
    copy_file 'app/models/_templates_/role.rb',
              'app/models/role.rb'
  end

  def cp_config
    copy_file 'config/initializers/the_role.rb',
              'config/initializers/the_role.rb'
  end

  def create_admin_role
    puts `clear`
    unless Role.with_name(:admin)
      TheRole.create_admin!
      puts "Admin role created"
    else
      puts "Admin role exists"
    end
  end
end
