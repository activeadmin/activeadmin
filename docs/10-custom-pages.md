# Custom Pages

Although it's nice to be able to register resources, sometimes you need a non
resourceful page in your application. Active Admin supports the generation of
custom pages using the same familiar syntax available for resources.

## Create a new Page

Creating a page is a simple as calling the `register_page` method:

    ActiveAdmin.register_page "My Page" do
      content do
        para "Hello World"
      end
    end

In the above example, a new page will be created at `/admin/my_page` with the
title "My Page" and the content of "Hello World". Anything rendered within the
`#content` block will be set in the main content area of the page.

## Page Title & I18n

Coming soon...

## Customize the Menu

The menu item is available to customize just like in any other resource in
Active Admin:

    ActiveAdmin.register_page "My Page" do
      menu :label => "My Menu Item Label", :parent => "Dashboard"

      content do
        para "Hello World"
      end
    end

This configuration will add the page to the menu with the label "My Menu Item
Label" and will nest it underneath the "Dashboard" link.

To view the full list of available menu options visit ([Resource
Customization](2-resource-customization.md))

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

This configuration creates a sidebar section named "Help" with an unordered list
in it. 

To view the full list of available sidebar section options visit
([Sidebars](7-sidebars.md))

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

This configuration adds an action item that links to the root URL of the
application.
