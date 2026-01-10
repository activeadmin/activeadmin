# Pagination adapter abstraction

Active Admin 4.0 introduces a pagination adapter abstraction to make pagination pluggable.

- Default adapter: `ActiveAdmin::KaminariAdapter` (uses Kaminari)
- Base API: `ActiveAdmin::PaginationAdapter`

## Configure the adapter

You can switch adapters per-namespace:

```ruby
# config/initializers/active_admin.rb
ActiveAdmin.setup do |config|
  # default for all namespaces
  config.pagination_adapter = ActiveAdmin::KaminariAdapter

  # per-namespace
  config.namespace :admin do |admin|
    admin.pagination_adapter = ActiveAdmin::KaminariAdapter
  end
end
```

You can also set it via string if you prefer delayed constantization:

```ruby
config.pagination_adapter = "ActiveAdmin::KaminariAdapter"
```

## Adapter contract

Implement a subclass of `ActiveAdmin::PaginationAdapter`:

- initialize(resource, params)
- paginate(collection, page: nil, per_page: nil) -> a collection representing the requested page
- paginated?(collection) -> whether the collection is already paginated

The base class provides helpers:

- page_value(override)
- per_page_value(override)
- page_param_name (defaults to `:page`)

## Example: a simple array adapter

```ruby
class MyArrayAdapter < ActiveAdmin::PaginationAdapter
  def paginate(collection, page: nil, per_page: nil)
    items = Array(collection)
    p = page_value(page).to_i
    size = per_page_value(per_page).to_i
    start = (p - 1) * size
    items.slice(start, size) || []
  end

  def paginated?(collection)
    false
  end
end
```

Then configure:

```ruby
ActiveAdmin.setup do |config|
  config.pagination_adapter = MyArrayAdapter
end
```

## View impact

This change is internal to controllers; existing views and helpers continue to work with Kaminari pagination and the pagination UI.

## Backwards compatibility

- The default behavior remains Kaminari-based.
- If you disable pagination in a resource (`config.paginate = false`), the controller uses `max_per_page` to cap batch sizes for exports.
