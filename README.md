<h2 align="center" class='center' style="text-align:center">
  TheRole::Api. Role model and general API methods
</h2>

<p align="center" class='center' style="text-align:center">
  <b>Authorization gem for Ruby on Rails</b><br>
  <i>with <a href="https://github.com/TheRole/TheRoleManagementPanelBootstrap3">Management Panel</a></i>
</p>

<p align="center" class='center' style="text-align:center">
  <img src="https://raw.githubusercontent.com/TheRole/TheRoleApi/master/docs/the_role.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

<p align="center" class='center' style="text-align:center">
  <b>Semantic. Flexible. Lightweigh</b>
</p>

<div align="center" class='center' style="text-align:center">

<a href="http://badge.fury.io/rb/the_role"><img src="https://badge.fury.io/rb/the_role.svg" alt="Gem Version" height="18"></a>
&nbsp;
<a href="https://travis-ci.org/TheRole/DummyApp"><img src="https://travis-ci.org/TheRole/DummyApp.svg?branch=master" alt="Build Status" height="18"></a>
&nbsp;
<a href="https://codeclimate.com/github/TheRole/TheRoleApi"><img src="https://codeclimate.com/github/TheRole/TheRoleApi/badges/gpa.svg" /></a>
&nbsp;
<a href="https://www.ruby-toolbox.com/categories/rails_authorization">ruby-toolbox</a>
</div>

### INTRO

TheRole is an authorization library for Ruby on Rails which restricts what resources a given user is allowed to access. All permissions are defined in with **2-level-hash**, and **stored in the database as a JSON string**.

<p align="center" class='center' style="text-align:center">
  <img src="./docs/hash2string.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

Using hashes, makes role system extremely easy to configure and use

* Any Role is a two-level hash, consisting of the <b>sections</b> and nested <b>rules</b>
* A <b>Section</b> may be associated with a <b>controller</b> name
* A <b>Rule</b> may be associated with an <b>action</b> name
* A Section can have many rules
* A Rule can be <b>true</b> or <b>false</b>
* <b>Sections</b> and nested <b>Rules</b> provide an <b>ACL</b> (<b>Access Control List</b>)

#### Import/Export

If you have 2 Rails apps, based on TheRole - you can move roles between them via export/import abilities of TheRole Management Panel.
It can be usefull for Rails apps based on one engine.

<div align="center" class='center' style="text-align:center">
  <img src="./docs/import_export.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</div>

### Limitations by Design

TheRole uses few conventions over configuration.
It gives simplicity of code, but also some limitations.
You have to know about them before using of TheRole:
<a href="https://github.com/TheRole/the_role_api/blob/master/docs/Limitations.md">Limitations list</a>

## Installation

#### Gemfile

```ruby
# only API
gem 'the_role_api', '~> 3.0.0'
```

or

```ruby
# living on bleeding edge
gem 'the_role_api',
  github: 'TheRole/the_role_api',
  branch: 'master'
```

or

```ruby
# API and UI
gem 'the_role', '~> 3.0.0'
```

and after that

```sh
bundle
```

#### Change User migration file

Add a `role_id:integer` field to your User Model

```ruby
def self.up
  create_table :users do |t|
    t.string :login
    t.string :email
    t.string :crypted_password
    t.string :salt

    # !!! TheRole field !!!
    t.integer :role_id

    t.timestamps
  end
end
```

#### Install TheRole migration file

```sh
bundle exec rake the_role_engine:install:migrations
```

#### Invoke migrations

```sh
rake db:migrate
```

#### Change User model

```ruby
class User < ActiveRecord::Base
  # include TheRole::Api::User
  has_the_role

  # ... code ...
end
```

#### Create Role model

```sh
bundle exec rails g the_role install
```

#### Setup TheRole gem

<i>config/initializers/the_role.rb</i>

```ruby
TheRole.configure do |config|
  # [ Devise => :authenticate_user! | Sorcery => :require_login ]
  config.login_required_method = :authenticate_user!

  # config.default_user_role          = nil
  # config.first_user_should_be_admin = false

  # config.access_denied_method       = :access_denied
  # config.destroy_strategy           = :restrict_with_exception # can be nil
  # config.layout                     = :application             # layout for Management panel
end
```

#### Create admin role

```sh
rake db:the_role:admin
```

Now you can make any user an Admin via `rails console`, for instance:

```ruby
User.first.update( role: Role.with_name(:admin) )
User.first.admin? # => true
```

<hr>

<p align="center" class='center' style="text-align:center">
  <b>
    You are in deal!<br>
    Thanks for using TheRole!
  </b>
</p>

<hr>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/the_role_api/blob/master/docs/IntegrationWithRailsControllers.md">
    <img src="https://raw.githubusercontent.com/TheRole/the_role_api/master/docs/int_ctrl.png" alt="Integration with Rails controllers">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/the_role_api/blob/master/docs/IntegrationWithRailsViews.md">
    <img src="https://raw.githubusercontent.com/TheRole/the_role_api/master/docs/int_views.png" alt="Integration with Rails views">
  </a>
</div>

<div align="center" class='center' style="text-align:center">
  <a href="https://github.com/TheRole/the_role_api/blob/master/docs/UsingWithStrongParameters.md">
    <img src="https://raw.githubusercontent.com/TheRole/the_role_api/master/docs/int_params.png" alt="Using with Strong Parameters">
  </a>
</div>

## TheRole API

### User

```ruby
# User's role
@user.role # => Role obj
```

Is a user Administrator?

```ruby
@user.admin?                       => true | false
```

Is a user Moderator?

```ruby
@user.moderator?(:pages)           => true | false
@user.moderator?(:blogs)           => true | false
@user.moderator?(:articles)        => true | false
```

Has user got access to **rule** of **section** (action of controller)?

```ruby
@user.has_role?(:pages,    :show)  => true | false
@user.has_role?(:blogs,    :new)   => true | false
@user.has_role?(:articles, :edit)  => true | false

# return true if one of roles is true
@user.any_role?(pages: :show, posts: :show) => true | false
```

Is user **Owner** of object?

```ruby
@user.owner?(@page)                => true | false
@user.owner?(@blog)                => true | false
@user.owner?(@article)             => true | false
```

### Role

```ruby
# Find a Role by name
@role = Role.with_name(:user)
```

```ruby
@role.has?(:pages, :show)       => true | false
@role.moderator?(:pages)        => true | false
@role.admin?                    => true | false

# return true if one of roles is true
@role.any?(pages: :show, posts: :show)     => true | false
@role.any?(pages: [:show], posts: [:show]) => true | false

@role.any?(pages: [:top_secret])                        => true | false
@role.any?(pages: [:show, :top_secret], posts: [:edit]) => true | false
```

#### CREATE

```ruby
# Create a section of rules
@role.create_section(:pages)
```

```ruby
# Create rule in section (false value by default)
@role.create_rule(:pages, :index)
```

#### READ

```ruby
@role.to_hash => Hash

# JSON string
@role.to_json => String

# check method
@role.has_section?(:pages) => true | false
```

#### UPDATE

```ruby
# set this rule on
@role.rule_on(:pages, :index)
```

```ruby
# set this rule off
@role.rule_off(:pages, :index)
```

```ruby
# Incoming hash is true-mask-hash
# All the rules of the Role will be reset to false
# Only rules from true-mask-hash will be set true
new_role_hash = {
  :pages => {
    :index => true,
    :show => true
  }
}

@role.update_role(new_role_hash)
```

#### DELETE

```ruby
# delete a section
@role.delete_section(:pages)

# delete a rule in section
@role.delete_rule(:pages, :show)
```

### MIT License

Copyright (c) 2012-2015 [Ilya N.Zykin]
