# frozen_string_literal: true
ActiveAdmin.register Post do
  permit_params :custom_category_id, :author_id, :title, :body, :published_date, :position, :starred, taggings_attributes: [ :id, :tag_id, :name, :position, :_destroy ]

  filter :author
  filter :category, as: :check_boxes
  filter :taggings
  filter :tags, as: :check_boxes
  filter :title
  filter :body
  filter :published_date
  filter :position
  filter :starred
  filter :foo_id
  filter :created_at
  filter :updated_at
  filter :custom_title_searcher
  filter :custom_created_at_searcher
  filter :custom_searcher_numeric

  belongs_to :author, class_name: "User", param: "user_id", route_name: "user"

  config.per_page = [ 5, 10, 20 ]

  includes :author, :category, :taggings

  scope :all, default: true

  scope :drafts, group: :status do |posts|
    posts.where(["published_date IS NULL"])
  end

  scope :scheduled, group: :status do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date > ?", Time.current])
  end

  scope :published, group: :status do |posts|
    posts.where(["posts.published_date IS NOT NULL AND posts.published_date < ?", Time.current])
  end

  scope :my_posts, group: :author do |posts|
    posts.where(author_id: current_admin_user.id)
  end

  batch_action :set_starred, partial: "starred_batch_action_form", link_html_options: { "data-modal-target": "starred-batch-action-modal", "data-modal-show": "starred-batch-action-modal" } do |ids, inputs|
    Post.where(id: ids).update_all(starred: inputs["starred"].present?)
    redirect_to collection_path(user_id: params["user_id"]), notice: "The posts have been updated."
  end

  index do
    selectable_column
    id_column
    column :title, class: "min-w-[150px]"
    column :published_date, class: "min-w-[170px]"
    column :author
    column :category
    column :starred
    column :position
    column :created_at, class: "min-w-[200px]"
    column :updated_at, class: "min-w-[200px]"
  end

  member_action :toggle_starred, method: :put do
    resource.update(starred: !resource.starred)
    redirect_to resource_path, notice: "Post updated."
  end

  action_item :toggle_starred, only: :show do
    link_to "Toggle Starred", toggle_starred_admin_user_post_path(resource.author, resource), method: :put, class: "action-item-button"
  end

  show do
    attributes_table_for(resource) do
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

    div class: "grid grid-cols-1 md:grid-cols-2 gap-4 my-4" do
      div do
        panel "Tags" do
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
      div do
        panel "Category" do
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
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs "Details", class: "mb-6" do
      f.input :title
      f.input :author
      f.input :published_date,
              hint: f.object.persisted? && "Created at #{f.object.created_at}"
      f.input :custom_category_id
      f.input :category, hint: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras tincidunt porttitor massa eu consequat. Suspendisse potenti. Curabitur gravida sem vel elit auctor ultrices."
      f.input :position
      f.input :starred
    end
    f.inputs "Content", class: "mb-6" do
      f.input :body
    end
    f.inputs "Tags", class: "mb-6" do
      f.has_many :taggings, heading: false, sortable: :position do |t|
        t.input :tag
        t.input :_destroy, as: :boolean
      end
    end
    para "Press cancel to return to the list without saving.", class: "py-2"
    f.actions
  end
end
