ActiveAdmin.register Store do

  if ActiveAdmin::Dependency.rails == 4
    permit_params :name
  end

  index pagination_total: false

end
