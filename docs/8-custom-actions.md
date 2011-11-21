# Custom Controller Actions

Active Admin allows you to override and modify the underlying controller which
is generated for you. There are helpers to add collection and member actions, or
you can drop right in to the controller and modify its behavior.

## Collection Actions

A collection action is a controller action which operates on the collection of
resources. This method adds both the action to the controller as well as
generating a route for you.

To add a collection action, use the collection_action method:


    ActiveAdmin.register Post do

      collection_action :import_csv, :method => :post do
        # Do some CSV importing work here...
        redirect_to {:action => :index}, :notice => "CSV imported successfully!"
      end

    end

This collection action will generate a route at "/admin/posts/import_csv"
pointing to the Admin::PostsController#import_csv controller action.

## Member Actions

A member action is a controller action which operates on a single resource.

For example, to add a lock action to a user resource, you would do the
following:

    ActiveAdmin.register User do

      member_action :lock, :method => :put do
        user = User.find(params[:id])
        user.lock!
        redirect_to {:action => :show}, :notice => "Locked!"
      end

    end

This will generate a route at "/admin/users/:id/lock" pointing to the
Admin::UserController#lock controller action.

## Controller Action HTTP Verb

The collection_action and member_actions methods both accept the "method"
argument to set the HTTP verb for the controller action and route.

The generated routes will be scoped to the given method you pass in. By default
your action will use the :get verb.

## Rendering in Custom Actions

Custom controller actions support rendering within the standard Active Admin
layout. 

    ActiveAdmin.register Post do

      # /admin/posts/:id/comments
      member_action :comments do
        @post = Post.find(params[:id])

        # This will render app/views/admin/posts/comments.html.erb
      end

    end

If you would like to use the same view syntax as the rest of Active Admin, you
can use the Arbre file extension: .arb.

For example, create app/views/admin/posts/comments.html.arb with:

    table_for assigns[:post].comments do
      column :id
      column :author
      column :body do |comment|
        simple_format comment.body
      end
    end
    
### Custom Action Items

To include your own action items (like the New, Edit and Delete buttons), add an 
`action_item` block. For example, to add a "View on site" button to view a blog
post:

    action_item :only => :show do
      link_to('View on site', post_path(post)) if post.published?
    end

### Page Titles

The page title for the custom action will be the internationalized version of
the controller action name. For example, a member_action named "upload_csv" will
look up a translation key of "active_admin.upload_csv". If none are found, it
just title cases the controller action's name.

If this method doesn't work for your requirements, you can always set the
@page_title instance variable in your controller action to customize the page
title.

    ActiveAdmin.register Post do

      # /admin/posts/:id/comments
      member_action :comments do
        @post = Post.find(params[:id])
        @page_title = "#{@post.title}: Comments" # Set the page title

        # This will render app/views/admin/posts/comments.html.erb
      end

    end

## Modify the Controller

The generated controller is available to you within the registration block by
using the #controller method.

    ActiveAdmin.register Post do

      controller do
        # This code is evaluated within the controller class

        def define_a_method
          # Instance method
        end
      end

    end
