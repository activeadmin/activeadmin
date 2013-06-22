# Customizing the CSV format

Active Admin provides CSV file downloads on the index screen for each Resource.
By default it will render a CSV file with all the content columns of your
registered model.

Customizing the CSV format is as simple as customizing the index page.

    ActiveAdmin.register Post do
      csv do
        column :title
        column("Author") { |post| post.author.full_name }
      end
    end

You can set custom csv options:

    ActiveAdmin.register Post do
      csv :force_quotes => true do
        column :title
        column("Author") { |post| post.author.full_name }
      end
    end

You can set options for the CSV format system-wide:

    # config/initializers/active_admin.rb
    # Set the CSV builder separator
    config.csv_options = { :col_sep => ';' }

    # Force the use of quotes
    config.csv_options = { :force_quotes => true }
