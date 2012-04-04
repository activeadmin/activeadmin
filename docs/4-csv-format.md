# Customizing the CSV format

Active Admin provides CSV file downloads on the index screen for each Resource.
By default it will render a CSV file with all the content columns of your
registered model.

Customizing the CSV format is as simple as customizing the index page.

    ActiveAdmin.register Post do
      csv do
        column :title
        column("Author") { |post| post.author.full_name }
        separator ";"
      end
    end
