# Customizing the Form

Active Admin gives complete control over the output of the form by creating a thin DSL on top of
the fabulous DSL created by Formtastic (http://github.com/justinfrench/formtastic).

    ActiveAdmin.register Post do

      form do |f|
        f.inputs "Details" do
          f.input :title
          f.input :published_at, :label => "Publish Post At"
          f.input :category
        end
        f.inputs "Content" do
          f.input :body
        end
        f.actions
      end

    end

Please view the documentation for Formtastic to see all the wonderful things you can do:
http://github.com/justinfrench/formtastic

If you require a more custom form than can be provided through the DSL, you can pass
a partial in to render the form yourself.

For example:

    ActiveAdmin.register Post do
      form :partial => "form"
    end

Then implement app/views/admin/posts/_form.html.erb:

    <%= semantic_form_for [:admin, @post] do |f| %>
      <%= f.inputs :title, :body %>
      <%= f.actions :commit %>
    <% end %>
