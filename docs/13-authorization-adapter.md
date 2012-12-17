# Authorization Adapter

ActiveAdmin now offers the ability to define and use your own authorization 
adapter. If implemented, the '#authorized?' will be called when an action is 
taken. By default, '#authorized?' returns true.

## Setting up your own AuthorizationAdapter

Setting up your own AuthorizationAdapter is easy! The following example shows 
how to set up and tie your authorization adapter class to ActiveAdmin:

module ActiveAdmin
	class OnlyAuthorsAuthorization < ActiveAdmin::AuthorizationAdapter

		def authorized?(action, subject = nil)
			case subject
			when Post
				case action
				when ActiveAdmin::Authorization::UPDATE, 
          ActiveAdmin::Authorization::DESTROY
					false
				else
					true
				end

			when ActiveAdmin::Page
				if subject.name == "No Access"
					false
				else
					true
				end

			else
				true
			end
		end

	end
end

In order to tie OnlyAuthorsAuthorization to ActiveAdmin, go to your 
application's config/initializers/active_admin.rb and add/modify the line:

config.authorization_adapter = "ActiveAdmin::OnlyAuthorsAuthorization"

The authorization adapter can also be set without going through config by 
using the following line:

ActiveAdmin.application.namespace(:admin).authorization_adapter = 
  OnlyAuthorAuthorization

Now, whenever a controller action is performed, the OnlyAuthorsAuthorization's
'#authorized?' method will be called.

## Use an Existing Authorization Library

Integrating an existing authorization library is even simpler than defining 
your own. The following example lets ActiveAdmin use CanCan's existing 
authorization library.

ActiveAdmin::Application.inheritable_setting :cancan_ability_class, "Ability"

module ActiveAdmin
	class CanCanAdapter < AuthorizationAdapter
		
		def authorized?(action, subject=nil)
			cancan_ability.can?(action, subject)
		end
		
		def cancan_ability
			@cancan_ability ||= initialize_cancan_ability
		end

		def scope_collection(collection)
			collection.accessible_by(cancan_ability)
		end

		private

		def initialize_cancan_ability
			ability_class_name = resource.namespace.cancan_ability_class

			if ability_class_name.is_a?(String)
				ability_class = 
					ActiveSupport::Dependencies.constantize(ability_class_name)
			else
				ability_class = ability_class_name
			end

			ability_class.new(user)
		end
	end
end

In the case of this example, CanCan would require an Ability class to define 
access rules. The 'user' that is passed into the ability_class' initializer is 
whatever is returned from the '#current_active_admin_user' method in the 
controllor.

## Scoping Collections Using Authorization Libraries

By default, '#scoped_collection' returns the collection passed to it, but, if 
overridden, allows for the returning of all items in a collection that the 
calling user has access too. If we were using CanCan as our authorization 
library, we could do the following:

def scope_collection(collection)
	collection.accessible_by(cancan_ability)
end 

