ActiveAdmin.register <%= class_name %> do

# Available Filters
#<% class_name.constantize.new.attributes.keys.each do |attr| %>
# filter :<%= attr.gsub(/_id$/, '') %><% end %>

# Sample Index
#
# index do
#   selectable_column
#   id_column<% class_name.constantize.new.attributes.keys.each do |attr| %>
#   column :<%= attr.gsub(/_id$/, '') %><% end %>
#   actions
# end

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
