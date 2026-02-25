# frozen_string_literal: true
ActiveAdmin.register Store do
  permit_params :name, :review_status, :reject_reason

  preserve_default_filters!
  filter :review_status, as: :select, collection: config.resource_class.review_statuses, multiple: true
  filter :reject_reason, as: :select, collection: config.resource_class.reject_reasons

  index pagination_total: false
end
