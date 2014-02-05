# Customizing the Form

Active Admin gives you complete control over the output of the form by creating
a thin DSL on top of [Formtastic](https://github.com/justinfrench/formtastic):

```ruby
ActiveAdmin.register Post do

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :published_at, label: "Publish Post At"
      f.input :category
    end
    f.inputs 'Content', :body
    f.actions
  end

end
```

Please view [the documentation](http://github.com/justinfrench/formtastic)
for Formtastic to see all the wonderful things you can do.

## Partials

If you require a more custom form than the DSL can provide, use a partial instead:

```ruby
ActiveAdmin.register Post do
  form partial: 'form'
end
```

Which looks for something like this:

```erb
<%# app/views/admin/posts/_form.html.erb %>
<%= semantic_form_for [:admin, @post] do |f| %>
  <%= f.inputs :title, :body %>
  <%= f.actions do %>
    <%= f.action :submit %>
    <li class="cancel"><%= link_to 'Cancel', collection_path %></li>
  <% end %>
<% end %>
```

## Nested Resources

You can create forms with nested models using the `has_many` method:

```ruby
ActiveAdmin.register Post do

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :published_at, label: 'Publish Post At'
    end
    f.inputs 'Content', :body
    f.inputs do
      f.has_many :categories, heading: 'Themes', allow_destroy: true, new_record: false do |a|
        a.input :title
      end
    end
    f.inputs do
      f.has_many :taggings, sortable: :position do |t|
        t.input :tag
      end
    end
    f.inputs do
      f.has_many :comment, new_record: 'Leave Comment' do |b|
        b.input :body
      end
    end
    f.actions
  end

end
```

The `:allow_destroy` option adds a checkbox to the end of the nested form allowing
removal of the child object upon submission. Be sure to set `allow_destroy: true`
on the association to use this option.

The `:heading` option adds a custom heading. You can hide it entirely by passing `false`.

The `:new_record` option controls the visibility of the new record button (shown by default).
If you pass a string, it will be used as the text for the new record button.

The `:sortable` option adds a hidden field and will enable drag & drop sorting of the children. It 
expects the name of the column that will store the index of each child.

## Datepicker

ActiveAdmin offers the `datepicker` input, which uses the [jQueryUI datepicker](http://jqueryui.com/datepicker/).
The datepicker input accepts any of the options available to the standard jQueryUI Datepicker. For example:

```ruby
form do |f|
  f.input :starts_at, as: :datepicker, datepicker_options: { min_date: "2013-10-8",        max_date: "+3D" }
  f.input :ends_at,   as: :datepicker, datepicker_options: { min_date: 3.days.ago.to_date, max_date: "+1W +5D" }
end
```

## Displaying Errors

To display a list of all validation errors:

```ruby
form do |f|
  f.semantic_errors *f.object.errors.keys
  f.inputs
  f.actions
end
```

This is particularly useful to display errors on virtual or hidden attributes.
