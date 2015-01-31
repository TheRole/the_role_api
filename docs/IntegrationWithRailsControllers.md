<a href="https://github.com/TheRole/the_role_api">[ Back to TheRole API ]</a>

## Integration with Rails controllers

<i>application_controller.rb</i>

```ruby
class ApplicationController < ActionController::Base

  include TheRole::Controller

  protect_from_forgery with: :exception
  protect_from_forgery

  # ... code ...
end
```

Any Rails controller, for instance, `pages_controller.rb`

```ruby
class PagesController < ApplicationController
  before_action :login_required, except: [ :index, :show ]
  before_action :role_required,  except: [ :index, :show ]

  # !!! ATTENTION !!!
  #
  # `@owner_check_object` variable have to be instantiated
  # before check ownership via `owner_required` method.
  #
  # You have to instantiate `@owner_check_object` in `set_page` method
  # See code below

  before_action :set_page,       only: [ :edit, :update, :destroy ]
  before_action :owner_required, only: [ :edit, :update, :destroy ]

  private

  def set_page
    @page = Page.find params[:id]

    # TheRole: object for ownership checking
    @owner_check_object = @page
  end
end
```

Please, learn simple source code of restriction methods:

0. <a href="https://github.com/TheRole/the_role_api/blob/master/app/controllers/concerns/the_role/controller.rb#L3">login_required</a>
0. <a href="https://github.com/TheRole/the_role_api/blob/master/app/controllers/concerns/the_role/controller.rb#L16">role_required</a>
0. <a href="https://github.com/TheRole/the_role_api/blob/master/app/controllers/concerns/the_role/controller.rb#L20">owner_required</a>

In this case `login_required` is a method `:authenticate_user!` from Devise gem


<a href="https://github.com/TheRole/the_role_api">[ Back to TheRole API ]</a>
