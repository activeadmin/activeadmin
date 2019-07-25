ActiveAdmin.register User do
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
            link_to post.id, admin_user_post_path(post.author, post)
          end
          column :title
          column :published_date
          column :category
          column :created_at
          column :updated_at
        end
      end

      para do
        link_to "View all posts", admin_user_posts_path(user)
      end
    end
  end
end
