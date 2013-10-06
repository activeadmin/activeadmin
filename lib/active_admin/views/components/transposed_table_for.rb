class TransposedTableFor < Arbre::HTML::Table
  builder_method :transposed_table_for

  def tag_name
    'table'
  end

  def build(collection, options = {})
    @resource_class = options.delete(:i18n)
    @collection = collection
    @columns = []
    build_table

    super(options)

    add_class "transposed"
  end

  def column(*args, &block)
    options = default_options.merge(args.extract_options!)
    title = args[0]
    data  = args[1] || args[0]

    col = Column.new(title, data, @resource_class, options, &block)
    @columns << col

    if @columns.size == 1
      within @header_row do
        th(col.pretty_title, class: col.html_class)

        @collection.each do |item|
          build_table_header(col, item)
        end
      end
    else

      # Build a row
      within @tbody do
        classes = Arbre::HTML::ClassList.new
        classes << cycle('odd', 'even')
        classes << col.html_class

        tr(:class => classes) do
          build_table_head_cell(col)

          @collection.each do |item|
            build_table_cell(col, item)
          end
        end
      end
    end
  end

  # Returns the columns to display based on the conditional block
  def visible_columns
    @visible_columns ||= @columns.select{ |col| col.display_column? }
  end

  protected

  def build_table
    build_table_head
    build_table_body
  end

  def build_table_header(col, item)
    th(:class => col.html_class) do
      render(col, item)
    end
  end

  def build_table_head_cell(col)
    classes = Arbre::HTML::ClassList.new
    classes << col.html_class
    th(col.pretty_title, :class => classes)
  end

  def build_table_head
    @thead = thead do
      @header_row = tr
    end
  end

  def build_table_body
    @tbody = tbody
  end

  def build_table_cell(col, item)
    td(:class =>  col.html_class) do
      render(col, item)
    end
  end

  def render(col, item)
    rvalue = call_method_or_proc_on(item, col.data, :exec => false)
    if col.data.is_a?(Symbol)
      rvalue = pretty_format(rvalue)
    end
    rvalue
  end

  def default_options
    {
      :i18n => @resource_class
    }
  end

  class Column

    attr_accessor :title, :data , :html_class

    def initialize(*args, &block)
      @options = args.extract_options!

      @title = args[0]
      @html_class = @options.delete(:class) || @title.to_s.downcase.underscore.gsub(/ +/,'_')
      @data  = args[1] || args[0]
      @data = block if block
      @resource_class = args[2]
    end

    def pretty_title
      if @title.is_a?(Symbol)
        default_title =  @title.to_s.titleize
        if @options[:i18n] && @options[:i18n].respond_to?(:human_attribute_name)
          @title = @options[:i18n].human_attribute_name(@title, :default => default_title)
        else
          default_title
        end
      else
        @title
      end
    end
  end
end
