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
  end
end
```

You can also set custom CSV settings for an individual resource:

```ruby
ActiveAdmin.register Post do
  csv force_quotes: true, col_sep: ';' do
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
