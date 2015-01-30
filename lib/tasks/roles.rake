namespace :db do
  namespace :roles do
    # rake db:roles:admin
    desc 'create Admin Role'
    task :admin => :environment do
      puts `clear`

      unless Role.with_name(:admin)
        TheRole.create_admin!
        puts "Admin role created"
      else
        puts "Admin role exists"
      end
    end
  end
end
