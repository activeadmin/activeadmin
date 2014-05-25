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

    def column(name, &block)
      @columns << Column.new(name, @resource, block)
    end

    def build(view_context, receiver)
      options = ActiveAdmin.application.csv_options.merge self.options
      columns = build_columns view_context

      receiver << CSV.generate_line(columns.map(&:name), options)

      view_context.send(:collection).find_each do |resource|
        receiver << CSV.generate_line(build_row(resource, columns, options), options)
      end
    end

    def build_columns(view_context = nil)
      @view_context = view_context
      @columns = [] # we want to re-render these every instance
      instance_eval &@block if @block.present?
      columns
    end

    def build_row(resource, columns, options)
      columns.map do |column|
        s = call_method_or_proc_on resource, column.data

        if options[:encoding] && s.respond_to?(:encode!)
          s.encode! options[:encoding], options[:encoding_options]
        else
          s
        end
      end
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
