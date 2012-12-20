# Authorization Adapter

Active Admin offers the ability to define and use your own authorization 
adapter. If implemented, the '#authorized?' will be called when an action is 
taken. By default, '#authorized?' returns true.

## Setting up your own AuthorizationAdapter

Setting up your own `AuthorizationAdapter` is easy! The following example shows 
how to set up and tie your authorization adapter class to Active Admin:

    # app/models/only_authors_authorization.rb
    class OnlyAuthorsAuthorization < ActiveAdmin::AuthorizationAdapter

        def authorized?(action, subject = nil)
          case subject
          when normalize(Post)

            # Only let the author update and delete posts
            if action == :update || action == :destroy
              subject.author == user

            # If it's not an update or destroy, anyone can view it
            else
              true
            end

          else
            true
          end
        end

    end

In order to hook up `OnlyAuthorsAuthorization` to Active Admin, go to your 
application's `config/initializers/active_admin.rb` and add/modify the line:

    config.authorization_adapter = "OnlyAuthorsAuthorization"

The authorization adapter can also be set without going through config by 
using the following line:

Now, whenever a controller action is performed, the `OnlyAuthorsAuthorization`'s
`#authorized?` method will be called.

## Getting Access to the Current User

From within your authorization adapter, you can call the `#user` method to 
retrieve the current user.

    class OnlyAdmins < ActiveAdmin::AuthorizationAdapter

      def authorized?(action, subject = nil)
        user.admin?
      end

    end

## Scoping Collections in Authorization Adapters

`ActiveAdmin::AuthorizationAdapter` also provides a hook method (`#scope_collection`) 
for the adapter to scope the resource's collection. For example, you may want to 
centralize the scoping:

    class OnlyMyAccount < ActiveAdmin::AuthorizationAdapter

      def authorized?(action, subject = nil)
        subject.account == user.account
      end

      def scope_collection(collection)
        collection.where(:account_id => user.account_id)
      end

    end

All collections presented on Index Screens will be passed through this method
and will be scoped accordingly.

## Managing Access to Pages

Pages, just like resources, get authorized also. When authorization a page, the
subject will be an instance of `ActiveAdmin::Page`.

    class OnlyDashboard < ActiveAdmin::AuthorizationAdapter
      def authorized?(action, subject = nil)
        case subject
        when ActiveAdmin::Page
          if action == :read && subject.name == "Dashboard"
            true
          else
            false
          end
        else
          false
        end
      end
    end

## Using the CanCan Adapter

Sub-classing `ActiveAdmin::AuthorizationAdapter` is fairly low level. Many times
it's nicer to have a simpler DSL for managing authorization. Active Admin
provides and adapter out of the box for CanCan.

To use the CanCan adapter, simply update the configuration in the Active Admin
initializer:

    config.authorization_adapter = ActiveAdmin::CanCanAdapter

By default this will use the ability class named "Ability". This can also be
changed from the initializer:

    config.cancan_ability_class = "MyCustomAbility"

Now you can simply use CanCan the way that you would expect and Active Admin
will use it for authorization:

    # app/models/ability.rb
    class Ability
      include CanCan::Ability

      def intialize(user)
        can :manage, Post
        can :read, User
        can :manage, User, :id => user.id
        can :read, ActiveAdmin::Page, :name => "Dashboard"
      end

    end

To view more details about the CanCan API, visit https://github.com/ryanb/cancan
