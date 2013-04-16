<!-- Please don't edit this file. It will be clobbered. -->

# Index as Blog

Render your index page as a set of posts. The post has two main options:
title and body.

    index :as => :blog do
      title :my_title # Calls #my_title on each resource
      body  :my_body  # Calls #my_body on each resource
    end

## Post Title

The title is the content that will be rendered within a link to the
resource. There are two main ways to set the content for the title

First, you can pass in a method to be called on your
resource. For example:

    index :as => :blog do
      title :a_method_to_call
    end

This will result in the title of the post being the return value of
Resource#a_method_to_call

Second, you can pass a block to the tile option which will then be
used as the contents fo the title. The resource being rendered
is passed in to the block. For Example:

    index :as => :blog do
      title do |post|
        span post.title, :class => 'title'
        span post.created_at, :class => 'created_at'
      end
    end

## Post Body

The body is rendered underneath the title of each post. The same two
style of options work as the Post Title above.

Call a method on the resource as the body:

    index :as => :blog do
      title :my_title
      body :my_body # Return value of #my_body will be the body
    end

Or, render a block as the body:

    index :as => :blog do
      title :my_title
      body do |post|
        div truncate(post.title)
        div :class => 'meta' do
          span "Post in #{post.categories.join(', ')}"
        end
      end
    end
