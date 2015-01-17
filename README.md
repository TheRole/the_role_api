<h2 align="center" class='center' style="text-align:center">
  TheRole::Api. Role model and general API methods
</h2>

<p align="center" class='center' style="text-align:center">
  <b>
  Authorization gem for Ruby on Rails<br>
  with Administrative interface
</p>

<p align="center" class='center' style="text-align:center">
  <img src="./docs/the_role.png" alt="TheRole. Authorization gem for Ruby on Rails with Administrative interface">
</p>

<p align="center" class='center' style="text-align:center">
  <b>Semantic. Flexible. Lightweigh</b>
</p>

<div align="center" class='center' style="text-align:center">

<a href="http://badge.fury.io/rb/the_role"><img src="https://badge.fury.io/rb/the_role.svg" alt="Gem Version" height="18"></a> &nbsp;
<a href="https://travis-ci.org/the-teacher/the_role"><img src="https://travis-ci.org/the-teacher/the_role.png?branch=master" alt="Build Status" height="18"></a>
&nbsp;
<a href="https://codeclimate.com/github/the-teacher/the_role"><img src="https://codeclimate.com/github/the-teacher/the_role.png" alt="Code Climate" height="18"></a>
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

# TheRole API

## User

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

## Role

```ruby
# Find a Role by name
@role = Role.with_name(:user)
```

```ruby
@role.has?(:pages, :show)       => true | false
@role.moderator?(:pages)        => true | false
@role.admin?                    => true | false

# return true if one of roles is true
@role.any?(pages: :show, posts: :show) => true | false
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

#### Changelog

* 2.3.0 - Refactoring
* 2.1.0 - User#any_role? & Role#any?
* 2.0.3 - create role fix, cleanup
* 2.0.2 - code cleanup, readme
* 2.0.1 - code cleanup
* 2.0.0 - Rails 4 ready, configurable, tests
* 1.7.0 - mass assignment for User#role_id, doc, locales, changes in test app
* 1.6.9 - assets precompile addon
* 1.6.8 - doc, re dependencies
* 1.6.7 - Es locale (beta 0.2)
* 1.6.6 - Ru locale, localization (beta 0.1)
* 1.6.5 - has_section?, fixes, tests (alpha 0.3)
* 1.6.4 - En locale (alpha 0.2)
* 1.6.3 - notifications
* 1.6.0 - stabile release (alpha 0.1)

### i18n

**Ru, En** (by me)

**Es** by @igmarin

**zh_CN** by @doabit & @linjunpop

**PL** by @egb3

### MIT-LICENSE

##### Copyright (c) 2012-2015 [Ilya N.Zykin]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
