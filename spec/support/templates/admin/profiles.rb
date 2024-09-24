# frozen_string_literal: true
ActiveAdmin.register Profile do
  menu parent: 'Users'
  permit_params :user_id, :bio
end
