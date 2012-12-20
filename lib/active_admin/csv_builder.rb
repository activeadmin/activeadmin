module ActiveAdmin
  # CSVBuilder stores CSV configuration
  #
  # Usage example:
  #
  #   csv_builder = CSVBuilder.new
  #   csv_builder.column :id
  #   csv_builder.column("Name") { |resource| resource.full_name }
  #
  #   csv_builder = CSVBuilder.new :separator => ";"
  #   csv_builder.column :id
  #
  #
  class CSVBuilder

    # Return a default CSVBuilder for a resource
    # The CSVBuilder's columns would be Id followed by this
    # resource's content columns
    def self.default_for_resource(resource)
      new.tap do |csv_builder|
        csv_builder.column(:id)
        resource.content_columns.each do |content_column|
          csv_builder.column(content_column.name.to_sym)
        end
      end
    end

    attr_reader :columns, :column_separator, :options

    def initialize(options={}, &block)
      @columns          = []
      @column_separator = options.delete(:separator)
      @options          = options.delete(:options)
      instance_eval &block if block_given?
    end

    # Add a column
    def column(name, &block)
      @columns << Column.new(name, block)
    end

    class Column
      attr_reader :name, :data
      
      def initialize(name, block = nil)
        @name = name.is_a?(Symbol) ? name.to_s.titleize : name
        @data = block || name.to_sym
      end
    end
  end
end
