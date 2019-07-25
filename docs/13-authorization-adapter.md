---
redirect_from: /docs/13-authorization-adapter.html
---

# Authorization Adapter

Active Admin offers the ability to define and use your own authorization
adapter. If implemented, the '#authorized?' will be called when an action is
taken. By default, '#authorized?' returns true.

## Setting up your own AuthorizationAdapter

The following example shows how to set up and tie your authorization
adapter class to Active Admin:

```ruby
# app/models/only_authors_authorization.rb
class OnlyAuthorsAuthorization < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    case subject
    when normalized(Post)
      # Only let the author update and delete posts
      if action == :update || action == :destroy
        subject.author == user
      else
        true
      end
    else
      true
    end
  end

end
```

In order to hook up `OnlyAuthorsAuthorization` to Active Admin, go to your
application's `config/initializers/active_admin.rb` and add/modify the line:

```ruby
config.authorization_adapter = "OnlyAuthorsAuthorization"
```

Now, whenever a controller action is performed, the `OnlyAuthorsAuthorization`'s
`#authorized?` method will be called.

Authorization adapters can be configured per ActiveAdmin namespace as well, for
example:

```ruby
ActiveAdmin.setup do |config|
  config.namespace :admin do |ns|
    ns.authorization_adapter = "AdminAuthorization"
  end
  config.namespace :my do |ns|
    ns.authorization_adapter = "DashboardAuthorization"
  end
end
```

## Getting Access to the Current User

From within your authorization adapter, you can call the `#user` method to
retrieve the current user.

```ruby
class OnlyAdmins < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    user.admin?
  end

end
```

## Scoping Collections in Authorization Adapters

`ActiveAdmin::AuthorizationAdapter` also provides a hook method
(`#scope_collection`) for the adapter to scope the resource's collection. For
example, you may want to centralize the scoping:

```ruby
class OnlyMyAccount < ActiveAdmin::AuthorizationAdapter

  def authorized?(action, subject = nil)
    subject.account == user.account
  end

  def scope_collection(collection, action = Auth::READ)
    collection.where(account_id: user.account_id)
  end

end
```

All collections presented on Index Screens will be passed through this method
and will be scoped accordingly.

## Managing Access to Pages

Pages, just like resources, get authorized too. When authorizing a page, the
subject will be an instance of `ActiveAdmin::Page`.

```ruby
class OnlyDashboard < ActiveAdmin::AuthorizationAdapter
  def authorized?(action, subject = nil)
    case subject
    when ActiveAdmin::Page
      action == :read &&
        subject.name == "Dashboard" &&
        subject.namespace.name == :admin
    else
      false
    end
  end
end
```

## Action Types

By default Active Admin simplifies the controller actions into 4 actions:

* `:read` - This controls if the user can view the menu item as well as the
  index and show screens.
* `:create` - This controls if the user can view the new screen and submit
  the form to the create action.
* `:update` - This controls if the user can view the edit screen and submit
  the form to the update action.
* `:destroy` - This controls if the user can delete a resource.

Each of these actions is available as a constant. Eg: `:read` is available as
`ActiveAdmin::Authorization::READ`.

## Checking for Authorization in Controllers and Views

Active Admin provides a helper method to check if the current user is
authorized to perform an action on a subject.

Use the `#authorized?(action, subject)` method to check.

```ruby
ActiveAdmin.register Post do

  index do
    column :title
    column '' do |post|
      link_to 'Edit', admin_post_path(post) if authorized? :update, post
    end
  end

end
```

If you are implementing a custom controller action, you can use the
`#authorize!` method to raise an `ActiveAdmin::AccessDenied` exception.

```ruby
ActiveAdmin.register Post do

  member_action :publish, method: :post do
    post = Post.find(params[:id])

    authorize! :publish, post
    post.publish!

    flash[:notice] = "Post has been published"
    redirect_to [:admin, post]
  end

  action_item :publish, only: :show do
    if !post.published? && authorized?(:publish, post)
      link_to "Publish", publish_admin_post_path(post), method: :post
    end
  end

end
```

## Using the CanCan Adapter

Sub-classing `ActiveAdmin::AuthorizationAdapter` is fairly low level. Many times
it's nicer to have a simpler DSL for managing authorization. Active Admin
provides an adapter out of the box for [CanCanCan](https://github.com/CanCanCommunity/cancancan).

To use the CanCan adapter, update the configuration in the Active Admin
initializer:

```ruby
config.authorization_adapter = ActiveAdmin::CanCanAdapter
```

You can also specify a method to be called on unauthorized access. This is
necessary in order to prevent a redirect loop that can happen if a user tries to
access a page they don't have permissions for (see
[#2081](https://github.com/activeadmin/activeadmin/issues/2081)).

```ruby
config.on_unauthorized_access = :access_denied
```

The method `access_denied` would be defined in `application_controller.rb`. Here
is one example that redirects the user from the page they don't have permission
to access to a resource they have permission to access (organizations in this
case), and also displays the error message in the browser:

```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  def access_denied(exception)
    redirect_to admin_organizations_path, alert: exception.message
  end
end
```

By default this will use the ability class named "Ability". This can also be
changed from the initializer:

```ruby
config.cancan_ability_class = "MyCustomAbility"
```

Now you can simply use CanCanCan the way that you would expect and
Active Admin will use it for authorization:

```ruby
# app/models/ability.rb
class Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Post
    can :read, User
    can :manage, User, id: user.id
    can :read, ActiveAdmin::Page, name: "Dashboard", namespace_name: "admin"
  end

end
```

To view more details about the API's, visit project pages of
[CanCanCan](https://github.com/CanCanCommunity/cancancan).

## Using the Pundit Adapter

Active Admin also provides an adapter out of the box for
[Pundit](https://github.com/varvet/pundit).

To use the Pundit adapter, update the configuration in the Active Admin
initializer:

```ruby
config.authorization_adapter = ActiveAdmin::PunditAdapter
```

Once that's done, Active Admin will pick up your Pundit policies, and use
them for authorization. For more information about setting up Pundit, see
[their documentation](https://github.com/varvet/pundit#installation).

Pundit also has [verify_authorized and/or verify_policy_scoped
methods](https://github.com/varvet/pundit#ensuring-policies-and-scopes-are-used)
to enforce usage of `authorized` and `policy_scope`. This conflicts with Active
Admin's authorization architecture, so if you're using those features, you'll
want to disable them for Active Admin's controllers:

```ruby
class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: :index, unless: :active_admin_controller?
  after_action :verify_policy_scoped, only: :index, unless: :active_admin_controller?

  def active_admin_controller?
    is_a?(ActiveAdmin::BaseController)
  end
end
```

If you want to use batch actions, ensure that `destroy_all?` method is defined
in your policy class. You can use this [template
policy](https://github.com/activeadmin/activeadmin/blob/master/spec/support/templates/policies/application_policy.rb)
in your application instead of default one generated by Pundit's
`rails g pundit:install` command.

In addition, there are [example policies](https://github.com/activeadmin/activeadmin/tree/master/spec/support/templates/policies/active_admin)
for restricting access to ActiveAdmin's pages and comments.
