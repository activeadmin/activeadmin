ActiveAdmin.register <%= class_name %> do

# Limit actions available to your users by adding them to the 'except' array
# actions :all, except: []

# Add or remove filters (you can use any ActiveRecord scope) to toggle their
# visibility in the sidebar
<%= @formatter.filters %>

# Add or remove columns to toggle their visiblity in the index action
# index do
#   selectable_column
#   id_column
<%= @formatter.columns %>
#   actions
# end

# Add or remove rows to toggle their visiblity in the show action
# show do |<%= class_name.downcase %>|
<%= @formatter.rows %>
# end

# Add or remove fields to toggle their visibility in the form

<% if Rails::VERSION::MAJOR == 4 || defined?(ActionController::StrongParameters) %>
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end
<% end %>
end
