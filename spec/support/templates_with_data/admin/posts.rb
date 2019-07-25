ActiveAdmin.register Post do
  permit_params :custom_category_id, :author_id, :title, :body, :published_date, :position, :starred, taggings_attributes: [ :id, :tag_id, :name, :position, :_destroy ]

  belongs_to :author, class_name: "User", param: "user_id", route_name: "user"

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
    redirect_to collection_path(user_id: params["user_id"]), notice: "The posts have been updated."
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
    link_to 'Toggle Starred', toggle_starred_admin_user_post_path(post.author, post), method: :put
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
end
