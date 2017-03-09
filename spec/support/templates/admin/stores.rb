ActiveAdmin.register Store do

  permit_params :name

  index pagination_total: false

end
