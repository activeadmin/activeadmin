# Batch Actions

By default, the index page provides you a "Batch Action" to quickly delete records,
as well as an API for you to easily create your own. Note that if you override the
default index, you must add `selectable_column` back for batch actions to be usable:

```ruby
index do
  selectable_column
  # ...
end
```

## Creating your own

Use the `batch_action` DSL method to create your own. It behaves just like a
controller method, so you can send the client whatever data you like. Your block
is passed an array of the record IDs that the user selected, so you can perform
your desired batch action on all of them:

```ruby
ActiveAdmin.register Post do
  batch_action :flag do |ids|
    batch_action_collection.find(ids).each do |post|
      post.flag! :hot
    end
    redirect_to collection_path, alert: "The posts have been flagged."
  end
end
```

### Disabling Batch Actions

You can disable batch actions at the application, namespace, or resource level:

```ruby
# config/initializers/active_admin.rb
ActiveAdmin.setup do |config|

  # Application level:
  config.batch_actions = false

  # Namespace level:
  config.namespace :admin do |admin|
    admin.batch_actions = false
  end
end

# app/admin/post.rb
ActiveAdmin.register Post do
  
  # Resource level:
  config.batch_actions = false
end
```

### Modification

If you want, you can override the default batch action to do whatever you want:

```ruby
ActiveAdmin.register Post do
  batch_action :destroy do |ids|
    redirect_to collection_path, alert: "Didn't really delete these!"
  end
end
```

### Removal

You can remove batch actions by simply passing false as the second parameter:

```ruby
ActiveAdmin.register Post do
  batch_action :destroy, false
end
```

### Conditional display

You can control whether or not the batch action is available via the `:if`
option, which is executed in the view context.

```ruby
ActiveAdmin.register Post do
  batch_action :flag, if: proc{ can? :flag, Post } do |ids|
    # ...
  end
end
```

### Priority in the drop-down menu

You can change the order of batch actions through the `:priority` option:

```ruby
ActiveAdmin.register Post do
  batch_action :destroy, priority: 1 do |ids|
    # ...
  end
end
```

### Confirmation prompt

You can pass a custom string to prompt the user with:

```ruby
ActiveAdmin.register Post do
  batch_action :destroy, confirm: "Are you sure??" do |ids|
    # ...
  end
end
```

### Batch Action forms

If you want to capture input from the user as they perform a batch action,
Active Admin has just the thing for you:

```ruby
batch_action :flag, form: {
  type: %w[Offensive Spam Other],
  reason: :text,
  notes:  :textarea,
  hide:   :checkbox,
  date:   :datepicker
} do |ids, inputs|
  # inputs is a hash of all the form fields you requested
  redirect_to collection_path, notice: [ids, inputs].to_s
end
```

If you pass a nested array, it will behave just like Formtastic would, with the first
element being the text displayed and the second element being the value.

```ruby
batch_action :doit, form: {user: [['Jake',2], ['Mary',3]]} do |ids, inputs|
  User.find(inputs[:user])
  # ...
end
```

When you have dynamic form inputs you can pass a proc instead:

```ruby
# NOTE: multi-pluck is new to Rails 4
batch_action :doit, form: ->{{user: User.pluck(:name, :id)}} do |ids, inputs|
  User.find(inputs[:user])
  # ...
end
```

Under the covers this is powered by the JS `ActiveAdmin.modal_dialog` which you can use yourself:

```coffee
if $('body.admin_users').length
  $('a[data-prompt]').click ->
    ActiveAdmin.modal_dialog $(@).data('prompt'), comment: 'textarea',
      (inputs)=>
        $.post "/admin/users/#{$(@).data 'id'}/change_state",
          comment: inputs.comment, state: $(@).data('state'),
          success: ->
            window.location.reload()
```

### Translation

By default, the name of the batch action will be used to lookup a label for the
menu. It will lookup in `active_admin.batch_actions.labels.#{your_batch_action}`.

So this:

```ruby
ActiveAdmin.register Post do
  batch_action :publish do |ids|
    # ...
  end
end
```

Can be translated with:

```yaml
# config/locales/en.yml
en:
  active_admin:
    batch_actions:
      labels:
        publish: "Publish"
```

### Support for other index types

You can easily use `batch_action` in the other index views, *Grid*, *Block*,
and *Blog*; however, these will require custom styling to fit your needs.

```ruby
ActiveAdmin.register Post do

  # By default, the "Delete" batch action is provided

  # Index as Grid
  index as: :grid do |post|
    resource_selection_cell post
    h2 auto_link post
  end

  # Index as Blog requires nothing special

  # Index as Block
  index as: :block do |post|
    div for: post do
      resource_selection_cell post
    end
  end

end
```

### BTW

In order to perform the batch action, the entire *Table*, *Grid*, etc. is
wrapped in a form that submits the IDs of the selected rows to your batch_action.

Since nested `<form>` tags in HTML often results in unexpected behavior, you
may need to modify the custom behavior you've built using to prevent conflicts.

Specifically, if you are using HTTP methods like `PUT` or `PATCH` with a custom
form on your index page this may result in your batch action being `PUT`ed
instead of `POST`ed which will create a routing error. You can get around this
by either moving the nested form to another page or using a POST so it doesn't
override the batch action. As well, behavior may vary by browser.
