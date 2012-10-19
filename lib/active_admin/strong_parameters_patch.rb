module ActiveAdmin
  # The following contains code provided by dpmccabe in https://gist.github.com/3718571
  module StrongParametersPatch
    extend ActiveSupport::Concern

    def initialize
      @instance_name = active_admin_config.resource_name.gsub(/(.)([A-Z])/,'\1_\2').downcase
      @klass = active_admin_config.resource_name.constantize

      @column_names = @klass.columns.map do |column|
        case column.type
        when :datetime, :date, :time
          ([column.name.to_sym] + (1..5).inject([]) { |acc, x| acc << :"#{column.name}(#{x}i)" })
        else
          column.name.to_sym
        end
      end.flatten

      super
    end

    def create
      resource_obj = instance_variable_set("@#{@instance_name}", @klass.new(params[@instance_name.to_sym].permit(*@column_names)))

      if resource_obj.save
        redirect_to send("admin_#{@instance_name}_path", resource_obj), notice: "Created #{@instance_name}."
      else
        render :new
      end
    end

    def update
      resource_obj = instance_variable_set("@#{@instance_name}", @klass.find(params[:id]))

      if resource_obj.update_attributes(params[@instance_name.to_sym].permit(*@column_names))
        redirect_to send("admin_#{@instance_name}_path", resource_obj), notice: "Updated #{@instance_name}."
      else
        render :edit
      end
    end
  end
end
