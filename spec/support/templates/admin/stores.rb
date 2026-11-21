# frozen_string_literal: true
ActiveAdmin.register Store do
  permit_params :name, :revenue

  index pagination_total: false
end
