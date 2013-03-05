# Custom Pages

When you need a standalone page on your site, Custom Pages will be there with a familiar syntax to resource registration.

## Available Features
* main page content
* menu item
* sidebars
* action_items
* page_actions

## Create a new Page

Creating a page is a simple as calling the `register_page` method:

    ActiveAdmin.register_page "My Page" do
      content do
        para "Hello World"
      end
    end

In the above example, a new page will be created at `/admin/my_page` with the
title "My Page" and the content of "Hello World". Anything rendered within
`content` will be the main content on the page.

## Page Title & I18n

Coming soon...

## Customize the Menu

The menu item is available to customize just like
[any other resource](2-resource-customization.md#customize-the-menu) in Active Admin.

## Add a Sidebar Section

You can add sidebar sections to your pages using the same DSL as other resources
in Active Admin:

    ActiveAdmin.register_page "My Page" do

      sidebar :help do
        ul do
          li "First Line of Help"
        end
      end

      content do
        para "Hello World"
      end
    end

This creates a sidebar section named "Help" containing an unordered list.
To view the full customization options, visit [Sidebars](7-sidebars.md).

## Add an Action Item

Just like other resources, you can add Action Item's to pages:

    ActiveAdmin.register_page "My Page" do

      action_item do
        link_to "View Site", "/"
      end

      content do
        para "Hello World"
      end
    end

This adds an action item that links to the root URL of the application.

## Add a Page Action

`page_action` allows you to define controller actions specific to this page,
and is the functional equivalent of `collection_action`.

    ActiveAdmin.register_page "My Page" do

      page_action :ex, :method => :post do
        # do stuff here
        redirect_to admin_my_page_path, :notice => "You did stuff!"
      end

      action_item do
        link_to "Do Stuff", admin_my_page_ex_path, :method => :post
      end

      content do
        para "Hello World"
      end
    end

This defines the route `/admin/my_page/ex` which can handle HTTP POST requests.

Clicking on the `action_item` will reload page with the message "You did stuff!"
