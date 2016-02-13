ActiveAdmin.register Store do

  if Rails::VERSION::MAJOR >= 4
    permit_params :name
  end

  index pagination_total: false

end
