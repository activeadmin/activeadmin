ActiveAdmin.register_page "KitchenSink" do
  sidebar "Sample Sidebar" do
    para "Sidebars can also be used on custom pages."
    para do
      a "Active Admin", href: "https://github.com/activeadmin/activeadmin"
      text_node "is a Ruby on Rails framework for"
      em "creating elegant backends"
      text_node "for"
      strong "website administration."
    end
    para do
      abbr "HTML", title: "HyperText Markup Language"
      text_node "is the most basic building block of the Web."
    end
  end

  content do
    columns do
      column do
        panel "Panel title" do
          h1 "This is an h1"
          h2 "This is an h2"
          h3 "This is an h3"
        end
      end
      column do
        table_for User.all do
          column :id
          column :display_name
          column :username
          column :age
          column :updated_at
        end
      end
    end

    tabs do
      tab :first do
        ul do
          li "List item"
          li "Another list item"
          li "Last item"
        end
        ol do
          li "First list item"
          li "Second list item"
          li "Third list item"
        end
      end
      tab :second do
        para "A popular quote."
        blockquote do
          text_node "&ldqou;Be yourself; everyone else is already taken.&rdqou;".html_safe
          cite "― Oscar Wilde"
        end
      end
      tab :third do
        para "Third tab content."
      end
    end
  end
end
