# frozen_string_literal: true
ActiveAdmin.register Store do
  permit_params :name, :review_status, :reject_reason

  index pagination_total: false
end
