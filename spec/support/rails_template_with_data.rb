apply File.expand_path("../rails_template.rb", __FILE__)

inject_into_file 'config/initializers/active_admin.rb', <<-RUBY, after: "ActiveAdmin.setup do |config|\n"

  config.comments_menu = { parent: 'Administrative' }
RUBY

inject_into_file 'app/admin/admin_user.rb', <<-RUBY, after: "ActiveAdmin.register AdminUser do\n"

  menu parent: "Administrative", priority: 1
RUBY

generate :'active_admin:page', 'KitchenSink'

gsub_file 'app/admin/kitchen_sink.rb', /^ *content.*?end/m, <<-RUBY

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
RUBY

%w{Post User Category Tag}.each do |type|
  generate :'active_admin:resource', type
end

inject_into_file 'app/admin/category.rb', <<-RUBY, after: "ActiveAdmin.register Category do\n"

  config.create_another = true

  permit_params [:name, :description]
RUBY

inject_into_file 'app/admin/user.rb', <<-RUBY, after: "ActiveAdmin.register User do\n"

  config.create_another = true

  permit_params [:first_name, :last_name, :username, :age]

  index as: :grid do |user|
    div for: user do
      resource_selection_cell user
      h2 link_to(user.display_name, admin_user_path(user)), style: 'margin-bottom: 0'
      para do
        strong user.username, style: 'text-transform: uppercase; font-size: 10px;'
        br
        em user.age
        text_node 'years old'
      end
    end
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row :last_name
      row :username
      row :age
      row :created_at
      row :updated_at
    end

    panel 'Posts' do
      table_for(user.posts.includes(:category).order(:updated_at).limit(10)) do
        column :id do |post|
          link_to post.id, admin_post_path(post)
        end
        column :title
        column :published_date
        column :category
        column :created_at
        column :updated_at
      end
      para do
        link_to "View all posts", admin_posts_path('q[author_id_eq]' => user.id)
      end
    end
  end
RUBY

inject_into_file 'app/admin/post.rb', <<-'RUBY', after: "ActiveAdmin.register Post do\n"

  permit_params :custom_category_id, :author_id, :title, :body, :published_date, :position, :starred, taggings_attributes: [ :id, :tag_id, :name, :position, :_destroy ]

  includes :author, :category, :taggings

  scope :all, default: true

  scope :drafts do |posts|
    posts.where(["published_date IS NULL"])
  end

  scope :scheduled do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date > ?", Time.now.utc])
  end

  scope :published do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date < ?", Time.now.utc])
  end

  scope :my_posts do |posts|
    posts.where(author_id: current_admin_user.id)
  end

  batch_action :set_starred, form: { starred: :checkbox } do |ids, inputs|
    Post.where(id: ids).update_all(starred: inputs['starred'].present?)
    redirect_to collection_path, notice: "The posts have been updated."
  end

  index do
    selectable_column
    id_column
    column :title
    column :published_date
    column :author
    column :category
    column :starred
    column :position
    column :created_at
    column :updated_at
  end

  sidebar :author, only: :show do
    attributes_table_for post.author do
      row :id do |author|
        link_to author.id, admin_user_path(author)
      end
      row :first_name
      row :last_name
      row :username
      row :age
    end
  end

  member_action :toggle_starred, method: :put do
    resource.update(starred: !resource.starred)
    redirect_to resource_path, notice: "Post updated."
  end

  action_item :toggle_starred, only: :show do
    link_to 'Toggle Starred', toggle_starred_admin_post_path(post), method: :put
  end

  show do |post|
    attributes_table do
      row :id
      row :title
      row :published_date
      row :author
      row :body
      row :category
      row :starred
      row :position
      row :created_at
      row :updated_at
    end

    columns do
      column do
        panel 'Tags' do
          table_for(post.taggings.order(:position)) do
            column :id do |tagging|
              link_to tagging.tag_id, admin_tag_path(tagging.tag)
            end
            column :tag, &:tag_name
            column :position
            column :updated_at
          end
        end
      end
      column do
        panel 'Category' do
          attributes_table_for post.category do
            row :id do |category|
              link_to category.id, admin_category_path(category)
            end
            row :description
          end
        end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs 'Details' do
          f.input :title
          f.input :author
          f.input :published_date,
            hint: f.object.persisted? && "Created at #{f.object.created_at}"
          f.input :custom_category_id
          f.input :category
          f.input :position
          f.input :starred
        end
      end
      column do
        f.inputs 'Content' do
          f.input :body
        end
      end
    end
    f.inputs "Tags" do
      f.has_many :taggings, sortable: :position do |t|
        t.input :tag
        t.input :_destroy, as: :boolean
      end
    end
    para "Press cancel to return to the list without saving."
    f.actions
  end
RUBY

inject_into_file 'app/admin/tag.rb', <<-RUBY, after: "ActiveAdmin.register Tag do\n"

  config.create_another = true

  permit_params [:name]

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions dropdown: true do |tag|
      item "Preview", admin_tag_path(tag)
    end
  end

RUBY

append_file "db/seeds.rb", "\n\n" + <<-RUBY.strip_heredoc
  users = ["Jimi Hendrix", "Jimmy Page", "Yngwie Malmsteen", "Eric Clapton", "Kirk Hammett"].collect do |name|
    first, last = name.split(" ")
    User.create!  first_name: first,
                  last_name: last,
                  username: [first,last].join('-').downcase,
                  age: rand(80)
  end

  categories = ["Rock", "Pop Rock", "Alt-Country", "Blues", "Dub-Step"].collect do |name|
    Category.create! name: name
  end

  published_at_values = [Time.now.utc - 5.days, Time.now.utc - 1.day, nil, Time.now.utc + 3.days]

  1_000.times do |i|
    user = users[i % users.size]
    cat = categories[i % categories.size]
    published = published_at_values[i % published_at_values.size]
    Post.create title: "Blog Post \#{i}",
                body: "Blog post \#{i} is written by \#{user.username} about \#{cat.name}",
                category: cat,
                published_date: published,
                author: user,
                starred: true
  end
RUBY

rake 'db:seed'
