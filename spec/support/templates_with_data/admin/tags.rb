ActiveAdmin.register Tag do
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
end
