# Forms

Active Admin gives you complete control over the output of the form by creating
a thin DSL on top of [Formtastic](https://github.com/justinfrench/formtastic):

```ruby
ActiveAdmin.register Post do

  form title: 'A custom title' do |f|
    inputs 'Details' do
      input :title
      input :published_at, label: "Publish Post At"
      li "Created at #{f.object.created_at}" unless f.object.new_record?
      input :category
    end
    panel 'Markup' do
      "The following can be used in the content below..."
    end
    inputs 'Content', :body
    para "Press cancel to return to the list without saving."
    actions
  end

end
```

For more details, please see Formtastic's documentation.

## Default

Resources come with a default form defined as such:

```ruby
form do |f|
  f.semantic_errors # shows errors on :base
  f.inputs          # builds an input field for every attribute
  f.actions         # adds the 'Submit' and 'Cancel' buttons
end
```

## Partials

If you want to split a custom form into a separate partial use:

```ruby
ActiveAdmin.register Post do
  form partial: 'form'
end
```

Which looks for something like this:

```ruby
# app/views/admin/posts/_form.html.arb
insert_tag active_admin_form_for resource do |f|
  inputs :title, :body
  actions
end
```

This is a regular Rails partial so any template engine may be used.

You can also use the `ActiveAdmin::FormBuilder` as builder in your Formtastic Form for use the same helpers are used in the admin file:

```ruby
  = semantic_form_for [:admin, @post], builder: ActiveAdmin::FormBuilder do |f|
    = f.inputs "Details" do
      = f.input :title
    - f.has_many :taggings, sortable: :position, sortable_start: 1 do |t|
      - t.input :tag
    = f.actions

```

## Nested Resources

You can create forms with nested models using the `has_many` method, even if your model uses `has_one`:

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
      f.has_many :taggings, sortable: :position, sortable_start: 1 do |t|
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

The `:sortable_start` option sets the value (0 by default) of the first position in the list.

## Datepicker

ActiveAdmin offers the `datepicker` input, which uses the [jQuery UI datepicker](http://jqueryui.com/datepicker/).
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
  # ...
end
```

This is particularly useful to display errors on virtual or hidden attributes.

# Tabs

You can arrange content in tabs as shown below:

```ruby
  form do |f|
    tabs do
      tab 'Basic' do
        f.inputs 'Basic Details' do
          f.input :email
          f.input :password
          f.input :password_confirmation
        end
      end

      tab 'Advanced' do
        f.inputs 'Advanced Details' do
          f.input :role
        end
      end
    end
    f.actions
  end
```
