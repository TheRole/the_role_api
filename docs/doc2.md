### Understanding

* [TheRole instead of CanCan?](#therole-instead-of-cancan)
* [What does it mean semantic?](#what-does-it-mean-semantic)
* [Virtual sections and rules](#virtual-sections-and-rules)
* [Using with Views](#using-with-views)
* [Who is Administrator?](#who-is-administrator)
* [Who is Moderator?](#who-is-moderator)
* [Who is Owner?](#who-is-owner)

### Instalation

* [INSTALL](#install)
* [INTEGRATION](#integration)
* [Configuration (optional)](#configuration)

## Install

```ruby
# You can use any Bootstrap 3 version (CSS, LESS, SCSS)
gem 'bootstrap-sass', github: 'thomas-mcdonald/bootstrap-sass'

gem "the_role", "~> 2.0.0"
```

```ruby
bundle
```

install note

```
bundle exec rails g the_role --help
```

### Change User migration

Add a **role_id:integer** field to your User Model

```ruby
def self.up
  create_table :users do |t|
    t.string :login
    t.string :email
    t.string :crypted_password
    t.string :salt

    # TheRole field
    t.integer :role_id

    t.timestamps
  end
end
```

### Change User model

```ruby
class User < ActiveRecord::Base
  include TheRole::User
  # or following alias for AR:
  # has_role

  # has_many :pages
end
```

### Create Role model

Generate Role model

```ruby
bundle exec rails g the_role install
```

or you can create Role model manually:

```ruby
class Role < ActiveRecord::Base
  include TheRole::Role
  # or following alias for AR:
  # acts_as_role
end
```

install TheRole migrations

```ruby
rake the_role_engine:install:migrations
```

Invoke migrations

```ruby
rake db:migrate
```

### Create Admin

Create admin role

```
bundle exec rails g the_role admin
```

Makes any user as Admin

```
User.first.update( role: Role.with_name(:admin) )
```

## Integration

#### Change your ApplicationController

**include TheRoleController** in your Application controller

```ruby
class ApplicationController < ActionController::Base
  include TheRole::Controller

  protect_from_forgery

  def access_denied
    flash[:error] = t('the_role.access_denied')
    redirect_to(:back)
  end
end
```

#### Mount routes

config/routes.rb

```ruby
  concern :the_role, TheRole::AdminRoutes.new

  namespace :admin do
    concerns :the_role
  end
```

### Configuration

create the_role config:

```
bundle exec rails g the_role config
```

**config/initializers/the_role.rb**

```ruby
TheRole.configure do |config|
  config.layout                = :application
  config.default_user_role     = :user
  config.access_denied_method  = :access_denied      # define it in ApplicationController
  config.login_required_method = :authenticate_user! # devise auth method

  # config.first_user_should_be_admin = false
  # config.destroy_strategy           = :restrict_with_exception # can be nil
end
```

#### Usage with any controller

```ruby
class PagesController < ApplicationController
  before_action :login_required, except: [:index, :show]
  before_action :role_required,  except: [:index, :show]

  before_action :set_page,       only: [:edit, :update, :destroy]
  before_action :owner_required, only: [:edit, :update, :destroy]

  def edit
     # ONLY OWNER CAN EDIT THIS PAGE
  end

  private

  def set_page
    @page = Page.find params[:id]

    # TheRole: You should define OWNER CHECK OBJECT
    # When editable object was found
    # You should define @owner_check_object before invoking **owner_required** method
    @owner_check_object = @page
  end
end
```

**integration with Inhirited Resource**

```ruby
  def owner_required
    @owner_check_object = resource
    super
  end
```

## Understanding

#### TheRole instead of CanCan?

TheRole, in contrast to CanCan, has a simple and predefined way to find the access state of the current role. If you don't want to create your own role scheme with CanCan Abilities - TheRole can be a great solution for you.

You can manage roles with a simple UI. TheRole's ACL structure is inspired by Rails' controllers, that's why it's so great for Rails applications.

#### What does semantic mean?

Semantic - the science of meaning. Humans should be able to quickly understand what is happening in a role system.

Look at the next Role hash. If you can understand access rules - this authorization system is semantic.

```ruby
role = {
  'pages' => {
    'index'   => true,
    'show'    => true,
    'new'     => false,
    'edit'    => false,
    'update'  => false,
    'destroy' => false
  },
  'articles' => {
    'index'  => true,
    'show'   => true
  },
  'twitter'  => {
    'button' => true,
    'follow' => false
  }
}
```

#### Virtual sections and rules

Usually, we use real names of controllers and actions for names of sections and rules:

```ruby
@user.has_role?(:pages, :show)
```

But, also, you can use virtual names of sections, and virtual names of section's rules.

```ruby
@user.has_role?(:twitter, :button)
@user.has_role?(:facebook, :like)
```

And you can use them as well as other access rules.

#### Usage within Views

```ruby
<% if @user.has_role?(:twitter, :button) %>
  Twitter Button is Here
<% else %>
  Nothing here :(
<% end %>
```

#### Who is Administrator?

Administrator is the user who can access any section and rules of your application.

Administrator is the owner of any objects in your application.

Administrator is the user, who has a virtual section **system** and a rule **administrator** in the role-hash.


```ruby
admin_role_fragment = {
  :system => {
    :administrator => true
  }
}
```

#### Who is Moderator?

Moderator is the user, who has access to any actions of some section(s).

Moderator is the owner of any objects of some class.

Moderator is the user, who has a virtual section **moderator**, with **section name** as rule name.

An example of a Moderator of Pages (controller) and Twitter (virtual section)

```ruby
moderator_role_fragment = {
  :moderator => {
    :pages   => true,
    :blogs   => false,
    :twitter => true
  }
}
```

#### Who is Owner?

Administrator is owner of any object in system.

Moderator of pages is owner of any page.

User is owner of objects, when **Object#user_id == User#id**.
