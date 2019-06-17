apply File.expand_path('rails_template.rb', __dir__)

inject_into_file 'config/initializers/active_admin.rb', <<-RUBY, after: "ActiveAdmin.setup do |config|"

  config.comments_menu = { parent: 'Administrative' }
RUBY

inject_into_file 'app/admin/admin_users.rb', <<-RUBY, after: "ActiveAdmin.register AdminUser do"

  menu parent: "Administrative", priority: 1
RUBY

copy_file File.expand_path('templates_with_data/admin/kitchen_sink.rb', __dir__), 'app/admin/kitchen_sink.rb'

%w{Post User Category Tag}.each do |type|
  generate :'active_admin:resource', type
end

inject_into_file 'app/admin/categories.rb', <<-RUBY, after: "ActiveAdmin.register Category do\n"

  config.create_another = true

  permit_params :name, :description
RUBY

inject_into_file 'app/admin/users.rb', <<-RUBY, after: "ActiveAdmin.register User do\n"

  config.create_another = true

  permit_params :first_name, :last_name, :username, :age

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
      paginated_collection(user.posts.includes(:category).order(:updated_at).page(params[:page]).per(10), download_links: false) do
        table_for(collection) do
          column :id do |post|
            link_to post.id, admin_post_path(post)
          end
          column :title
          column :published_date
          column :category
          column :created_at
          column :updated_at
        end
      end

      para do
        link_to "View all posts", admin_posts_path('q[author_id_eq]' => user.id)
      end
    end
  end
RUBY

inject_into_file 'app/admin/posts.rb', <<-'RUBY', after: "ActiveAdmin.register Post do\n"

  permit_params :custom_category_id, :author_id, :title, :body, :published_date, :position, :starred, taggings_attributes: [ :id, :tag_id, :name, :position, :_destroy ]

  includes :author, :category, :taggings

  scope :all, default: true

  scope :drafts, group: :status do |posts|
    posts.where(["published_date IS NULL"])
  end

  scope :scheduled, group: :status do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date > ?", Time.now.utc])
  end

  scope :published, group: :status do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date < ?", Time.now.utc])
  end

  scope :my_posts, group: :author do |posts|
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

inject_into_file 'app/admin/tags.rb', <<-RUBY, after: "ActiveAdmin.register Tag do\n"

  config.create_another = true

  permit_params :name

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
                  age: rand(80),
                  encrypted_password: SecureRandom.hex
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

  800.times do |i|
    ActiveAdmin::Comment.create!(
      namespace: :admin,
      author: AdminUser.first,
      body: "Test comment \#{i}",
      resource: categories.sample
    )
  end
RUBY

rake 'db:seed'

git add: '.'
git commit: "-m 'Bare application with data'"
