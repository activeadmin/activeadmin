# Customizing the CSV format

Active Admin provides CSV file downloads on the index screen for each Resource.
By default it will render a CSV file with all the content columns of your
registered model.

Customizing the CSV format is as simple as customizing the index page.

```ruby
ActiveAdmin.register Post do
  csv do
    column :title
    column(:author) { |post| post.author.full_name }
    column('bODY', humanize_name: false) # preserve case
  end
end
```

You can also set custom CSV settings for an individual resource:

```ruby
ActiveAdmin.register Post do
  csv force_quotes: true, col_sep: ';', column_names: false do
    column :title
    column(:author) { |post| post.author.full_name }
  end
end
```

Or system-wide:

```ruby
# config/initializers/active_admin.rb

# Set the CSV builder separator
config.csv_options = { col_sep: ';' }

# Force the use of quotes
config.csv_options = { force_quotes: true }
```

## Streaming

By default Active Admin streams the CSV response to your browser as it's generated.
This is good because it prevents request timeouts, for example the infamous H12
error on Heroku.

However if an exception occurs while generating the CSV, the request will eventually
time out, with the last line containing the exception message. CSV streaming is
disabled in development to help debug these exceptions. That lets you use tools like
better_errors and web-console to debug the issue. If you want to customize the
environments where CSV streaming is disabled, you can change this setting:

```ruby
# config/initializers/active_admin.rb

config.disable_streaming_in = ['development', 'staging']
```
