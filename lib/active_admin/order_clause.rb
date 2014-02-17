module ActiveAdmin
  class OrderClause
    attr_reader :field, :order

    def initialize(clause, order)
      clause =~ /^([\w\_\.]+)(->'\w+')?$/
      @column = $1
      @op = $2
      @order = order

      @field = [@column, @op].compact.join
    end

    def valid?
      @field.present? && @order.present?
    end

    def to_sql(active_admin_config)
      table = active_admin_config.resource_column_names.include?(@column) ? active_admin_config.resource_table_name : nil
      table_column = (@column =~ /\./) ? @column :
        [table, active_admin_config.resource_quoted_column_name(@column)].compact.join(".")

      [table_column, @op, ' ', @order].compact.join
    end
  end
end
