# Customizing the Form

Active Admin gives complete control over the output of the form by creating a thin DSL on top of
[Formtastic](http://github.com/justinfrench/formtastic).
```ruby
ActiveAdmin.register Post do

  form do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :published_at, label: 'Publish Post At'
      f.input :category
    end
    f.inputs 'Content' do
      f.input :body
    end
    f.actions
  end
end
```

Be sure to read the [Formtastic documentation](http://rdoc.info/github/justinfrench/formtastic)
so you know everything available to you.

If you require a more custom form than can be provided through the DSL, you can
pass a partial in to render the form in a separate file.

For example:
```ruby
ActiveAdmin.register Post do
  form partial: 'form'
end
```

Then implement `app/views/admin/posts/_form.html.erb`:
```erb
<%= semantic_form_for [:admin, @post] do |f| %>
  <%= f.inputs 'Post Details', :title, :body %>
  <%= f.actions %>
<% end %>
```

## Nested Resources

You can create forms with nested models using the `has_many` method:

```ruby
form do |f|
  f.inputs 'Details' do
    f.input :title
    f.input :published_at, label: 'Publish Post At'
  end
  f.inputs 'Content', :body
  f.has_many :categories, heading: 'Themes', allow_destroy: true, new_record: false do |cat|
    cat.input :title
  end
  f.actions
end
```

### Options

#### `heading`

This will add a custom heading to has_many form. You can hide the heading by setting it to `false`.

#### `allow_destroy`

This will add a checkbox to the end of the nested form allowing removal of the child object
upon submission. __Be sure to set `allow_destroy: true` on the association to use this option.__

#### `new_record`

This will show or hide new record link at the bottom of has_many form. It's set to `true` by default.
