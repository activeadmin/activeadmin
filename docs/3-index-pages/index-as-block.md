<!-- Please don't edit this file. It will be clobbered. -->

Simplest rendering possible. Calls the block for each element in the collection.

Example:

  ActiveAdmin.register Post do
    index :as => :block do |post|
      # render the post partial (app/views/admin/posts/_post)
      render 'post', :post => post 
    end
  end