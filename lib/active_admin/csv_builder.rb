module ActiveAdmin
  # CSVBuilder stores CSV configuration
  #
  # Usage example:
  #
  #   csv_builder = CSVBuilder.new
  #   csv_builder.column :id
  #   csv_builder.column("Name") { |resource| resource.full_name }
  #   csv_builder.column(:name, humanize: false)
  #   csv_builder.column("name", humanize: false) { |resource| resource.full_name }
  #
  #   csv_builder = CSVBuilder.new col_sep: ";"
  #   csv_builder = CSVBuilder.new humanize_name: false
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

    COLUMN_TRANSITIVE_OPTIONS = [:humanize_name].freeze

    def initialize(options={}, &block)
      @resource = options.delete(:resource)
      @columns, @options, @block = [], options, block
    end

    def column(name, options={}, &block)
      @columns << Column.new(name, @resource, column_transitive_options.merge(options), block)
    end

    def build(view_context, receiver)
      options = ActiveAdmin.application.csv_options.merge self.options
      columns = exec_columns view_context

      column_names = ( options.key?(:column_names) == !!options[:column_names] )
      options.except!(:column_names)
      if column_names
        receiver << CSV.generate_line(columns.map{ |c| encode c.name, options }, options)
      end

      view_context.send(:collection).find_each do |resource|
        resource = view_context.send :apply_decorator, resource
        receiver << CSV.generate_line(build_row(resource, columns, options), options)
      end
    end

    def exec_columns(view_context = nil)
      @view_context = view_context
      @columns = [] # we want to re-render these every instance
      instance_exec &@block if @block.present?
      columns
    end

    def build_row(resource, columns, options)
      columns.map do |column|
        encode call_method_or_proc_on(resource, column.data), options
      end
    end

    def encode(content, options)
      if options[:encoding]
        content.to_s.encode! options[:encoding], options[:encoding_options]
      else
        content
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
      attr_reader :name, :data, :options

      DEFAULT_OPTIONS = { humanize_name: true }

      def initialize(name, resource = nil, options = {}, block = nil)
        @options = options.reverse_merge(DEFAULT_OPTIONS)
        @name = humanize_name(name, resource, @options[:humanize_name])
        @data = block || name.to_sym
      end

      def humanize_name(name, resource, humanize_name_option)
        if humanize_name_option
          name.is_a?(Symbol) && resource.present? ? resource.human_attribute_name(name) : name.to_s.humanize
        else
          name.to_s
        end
      end
    end

    private

    def column_transitive_options
      @column_transitive_options ||= @options.slice(*COLUMN_TRANSITIVE_OPTIONS)
    end
  end
end
