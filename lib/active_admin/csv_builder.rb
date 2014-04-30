module ActiveAdmin
  # CSVBuilder stores CSV configuration
  #
  # Usage example:
  #
  #   csv_builder = CSVBuilder.new
  #   csv_builder.column :id
  #   csv_builder.column("Name") { |resource| resource.full_name }
  #
  #   csv_builder = CSVBuilder.new col_sep: ";"
  #   csv_builder.column :id
  #
  #
  class CSVBuilder

    # Return a default CSVBuilder for a resource
    # The CSVBuilder's columns would be Id followed by this
    # resource's content columns
    def self.default_for_resource(resource)
      new(resource: resource) do
        column(:id)
        resource.content_columns.each do |content_column|
          column(content_column.name.to_sym)
        end
      end
    end

    attr_reader :columns, :options, :view_context

    def initialize(options={}, &block)
      @resource = options.delete(:resource)
      @columns, @options, @block = [], options, block
    end

    # Add a column
    def column(name, &block)
      @columns << Column.new(name, @resource, block)
    end

    # Runs the `csv` dsl block and render our columns
    # Called from `index.csv.erb`, which passes in the current view context.
    # This provides methods that could be called in the views to be called within
    # the CSV block. Any method not defined on the CSV builder will instead be
    # sent to the view context in order to emulate the capabilities of the `index`
    # DSL.
    def render_columns(view_context = nil)
      @view_context = view_context
      @columns = [] # we want to re-render these every instance
      instance_eval &@block if @block.present?
      columns
    end

    def method_missing(method, *args, &block)
      if @view_context.respond_to? method
        @view_context.public_send method, *args, &block
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
