# Customizing the CSV format

Customizing the CSV format is as simple as customizing the index page.

  csv do
    column :name
    column("Author") { |post| post.author.full_name }
  end
