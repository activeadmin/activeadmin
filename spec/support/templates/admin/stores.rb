ActiveAdmin.register Store do

  controller do
    def permitted_params
      params.permit store: [:name]
    end if Rails::VERSION::MAJOR == 4
  end

end
