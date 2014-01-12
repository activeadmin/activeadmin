module ActiveAdmin
  # CSVBuilder stores CSV configuration
  #
  # Usage example:
  #
  #   csv_builder = CSVBuilder.new
  #   csv_builder.column :id
  #   csv_builder.column("Name") { |resource| resource.full_name }
  #
  #   csv_builder = CSVBuilder.new :col_sep => ";"
  #   csv_builder.column :id
  #
  # Note that by passing a :context to the CSV builder that will be used in
  # `method_missing` calls. This is used by Active Admin so you have access to the
  # full AA config object from within the CSV block. For example, it allows you to do this:
  #
  #    csv do
  #      controller.parent
  #      # ...
  #    end
  #
  class CSVBuilder

    # Return a default CSVBuilder for a resource
    # The CSVBuilder's columns would be Id followed by this
    # resource's content columns
    def self.default_for_resource(resource)
      new(resource: resource).tap do |builder|
        builder.column :id
        resource.content_columns.each do |content_column|
          builder.column content_column.name.to_sym
        end
      end
    end

    attr_reader :columns, :options

    def initialize(options={}, &block)
      @context           = options.delete :context
      @resource          = options.delete :resource
      @columns, @options = [], options
      instance_exec &block if block_given?
    end

    # Add a column
    def column(name, &block)
      @columns << Column.new(name, @resource, block)
    end

    def method_missing(*args, &block)
      if @context
        @context.send *args, &block
      else
        super
      end
    end

    class Column
      attr_reader :name, :data

      def initialize(name, resource = nil, block = nil)
        @name = name.is_a?(Symbol) && resource.present? ? resource.human_attribute_name(name) : name.to_s.humanize
        @data = block || name.to_sym
      end
    end
  end
end
