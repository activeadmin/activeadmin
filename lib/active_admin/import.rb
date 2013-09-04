
module ActiveAdmin
  class Importer

    # switch to ActiveModel::Model in Rails 4
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations

    def persisted?
      false
    end

    attr_accessor :klass, :file

    def initialize(klass, attributes = {})
      @klass = klass
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def save
      if resources.map(&:valid?).all?
        ActiveRecord::Base.transaction { resources.each &:save! }
        true
      else
        resources.each_with_index do |resource, index|
          resource.errors.full_messages.each do |message|
            errors.add :base, "Row #{index+2}: #{message}"
          end
        end
        false
      end
    end

    def resources
      @resources ||= load_resources
    end

    def load_resources
      spreadsheet = open_spreadsheet
      header      = spreadsheet[0].map { |s| s.downcase.underscore }
      spreadsheet[1..-1].map do |elems|
        attrs = Hash[[header, elems].transpose]
        resource = klass.where(:id => attrs['id']).first_or_initialize
        resource.attributes = attrs.slice *klass.accessible_attributes
        resource
      end
    end

    def open_spreadsheet
      raise 'Roo is missing!' unless defined? ::Roo
      case File.extname(file.original_filename)
      when ".csv"  then Roo::CSV.new file.path
      when ".xls"  then Roo::Excel.new file.path
      when ".xlsx" then Roo::Excelx.new file.path
      else raise "Unknown file type: #{file.original_filename}"
      end.to_a
    end

    module DSL

      def importable(options = {})

        action_item :only => :index do
          link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'import'
        end

        collection_action :import, method: [:get, :post] do
          @importer = Importer.new resource_class, params[:active_admin_importer] || {}
          if request.method == 'POST' && @importer.save
            redirect_to collection_path, notice: "Imported products successfully."
          else
            render :layout => false
          end
        end

      end

    end
  end
end

ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::Importer::DSL
