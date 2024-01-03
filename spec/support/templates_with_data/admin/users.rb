# frozen_string_literal: true
ActiveAdmin.register User do
  config.create_another = true

  permit_params :first_name, :last_name, :username, :age

  preserve_default_filters!
  filter :first_name_or_last_name_cont, as: :string, label: "First or Last Name"

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :username
    column :age
    column :created_at, class: "min-w-[13rem]"
    column :updated_at, class: "min-w-[13rem]"
    actions
  end

  index as: ActiveAdmin::Views::CustomIndex do |user|
    label do
      div class: "flex items-center gap-2 text-xl mb-2" do
        resource_selection_cell user
        span link_to(user.display_name, admin_user_path(user))
      end
      div "@#{user.username}", class: "mb-2"
      div "#{user.age} years old", class: "mb-2 font-semibold"
    end
  end

  show do
    attributes_table_for(resource) do
      row :id
      row :first_name
      row :last_name
      row :username
      row :age
      row :created_at
      row :updated_at
    end

    h3 "Posts", class: "font-bold py-5 text-2xl"

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

    div class: "mt-4" do
      link_to "View all posts", admin_user_posts_path(user)
    end
  end
end
