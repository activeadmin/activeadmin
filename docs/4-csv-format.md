# Customizing the CSV format

Active Admin provides CSV file downloads on the index page for each resource.
By default the CSV file will include every database attribute of the object,
but there's a familar DSL to customize the CSV export format.
```ruby
ActiveAdmin.register Post do
  csv do
    column :title
    column('Author') { |post| post.author.full_name }
  end
end
```

You can set custom csv options:
```ruby
ActiveAdmin.register Post do
  csv options: { force_quotes: true } do
    column :title
    column('Author') { |post| post.author.full_name }
  end
end
```

They can also be set system-wide:
```ruby
# config/initializers/active_admin.rb
config.csv_column_separator = ';'              # change the separator used
config.csv_options = { :force_quotes => true } # force the use of quotes
```
