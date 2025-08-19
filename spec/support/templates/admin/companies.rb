# frozen_string_literal: true
ActiveAdmin.register Company do
  permit_params :name, store_ids: []

  form do |f|
    f.inputs 'Company' do
      f.input :name
      f.input :stores
    end
    f.actions
  end

  show do
    attributes_table :name, :stores, :created_at, :update_at
  end
end
