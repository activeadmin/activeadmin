# frozen_string_literal: true
ActiveAdmin.register Category do
  config.create_another = true

  permit_params :name, :description
end
