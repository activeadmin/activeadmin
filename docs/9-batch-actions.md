---
redirect_from: /docs/9-batch-actions.html
---

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
you can supply a partial (e.g. modal form) that will be included
automatically in the index page output.

Assuming a Post resource (in the default namespace) with a `mark_published`
batch action, we set the partial name and a set of HTML data attributes to
trigger a modal using Flowbite which is included by default.

```ruby
ActiveAdmin.register Post do
  batch_action(
    :mark_published,
    partial: "mark_published_batch_action",
    link_html_options: {
      "data-modal-target": "mark-published-modal",
      "data-modal-show": "mark-published-modal"
    }
  ) do |ids, inputs|
    # inputs is a hash of all the form fields you requested
    redirect_to collection_path, notice: [ids, inputs].to_s
  end
end
```

::: tip
You can use any modal JS library as long as it can be triggered to open
using data attributes. Flowbite usage is optional.
:::

Assuming a partial named `_mark_published_batch_action.html.erb` exists in
the `app/views/admin/posts` directory, the contents will be included automatically
in the index page output for you.

Now update the partial with the modal form HTML where the root `id` attribute must
match the data attributes supplied in the earlier `batch_action` example. The
form **must** have an empty `data-batch-action-form` attribute.

```erb
<div id="mark-published-modal" class="hidden fixed top-0 ..." aria-hidden="true" ...>
  <!-- ... other modal content --->
  <%= form_tag false, "data-batch-action-form": "" do %>
    <!-- Declare your form inputs. You can use a different form builder too. -->
  <% end %>
</div>
```

The `data-batch-action-form` attribute is a hook for a delegated JS event so when you submit the form, it will post and run your batch action block with the supplied form data.

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

### Support for custom index views

You can use `batch_action` in a custom index view, however, these will require custom styling to fit your needs.

```ruby
ActiveAdmin.register Post do
  # By default, the "Delete" batch action is provided
  index as: :custom do |post|
    resource_selection_cell post
    h2 auto_link post
  end
```

### Note on implementation

In order to perform the batch action, the entire index view is
wrapped in a form that submits the IDs of the selected rows to your `batch_action`.

Since nested `<form>` tags in HTML often results in unexpected behavior, you
may need to modify the custom behavior you've built using to prevent conflicts.

Specifically, if you are using HTTP methods like `PUT` or `PATCH` with a custom
form on your index page this may result in your batch action being `PUT`ed
instead of `POST`ed which will create a routing error. You can get around this
by either moving the nested form to another page or using a `POST` so it doesn't
override the batch action. As well, behavior may vary by browser.
