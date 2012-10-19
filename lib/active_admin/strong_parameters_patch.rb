# lib/active_admin_extentions/strong_admin.rb
module ActiveAdmin
  # The following contains code provided by
  # dpmccabe in https://gist.github.com/3718571
  # jasperkennis in https://gist.github.com/3907216
  module StrongParametersPatch

    extend ActiveSupport::Concern

    def initialize
      @instance_name = active_admin_config.resource_class.name.underscore.to_sym
      @klass = active_admin_config.resource_class

      super
    end

    def create
      # TODO: allow controller-specified attribute permits
      resource_obj = instance_variable_set("@#{@instance_name}", @klass.new(params[@instance_name].permit!))

      if resource_obj.save
        redirect_to send("admin_#{@instance_name}_path", resource_obj), notice: "Created #{@instance_name}."
      else
        render :new
      end
    end

    def update
      resource_obj = instance_variable_set("@#{@instance_name}", @klass.find(params[:id]))
      
      # TODO: allow controller-specified attribute permits
      if resource_obj.update_attributes(params[@instance_name].permit!)
        redirect_to send("admin_#{@instance_name}_path", resource_obj), notice: "Updated #{@instance_name}."
      else
        render :edit
      end
    end
  end
end
