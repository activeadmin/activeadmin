# Customizing the Show Screen

Customizing the show screen is as simple as implementing the show block:

    ActiveAdmin.register Post do
      show do
        h3 post.title
        div do
          simple_format post.body
        end
      end
    end

The show block is rendered within the context of the view and uses the Arbre HTML DSL. You
can also render a partial at any point.

    ActiveAdmin.register Post do
      show do
        # renders app/views/admin/posts/_some_partial.html.erb
        render "some_partial"
      end
    end
