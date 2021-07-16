# frozen_string_literal: true
ActiveAdmin.register Tag do
  config.create_another = true

  permit_params :name

  index has_footer: true do
    selectable_column
    id_column
    column :name, footer: "Total:"
    column :created_at, footer: :count
    actions dropdown: true do |tag|
      item "Preview", admin_tag_path(tag)
    end
  end
end
