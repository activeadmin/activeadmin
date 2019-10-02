module ActiveAdmin
  class OrderClause
    attr_reader :field, :order, :active_admin_config

    def initialize(active_admin_config, clause)
      clause =~ /^([\w\.]+)(->'\w+')?_(desc|asc)$/
      @column = $1
      @op = $2
      @order = $3
      @active_admin_config = active_admin_config
      @field = [@column, @op].compact.join
    end

    def valid?
      @field.present? && @order.present?
    end

    def apply(chain)
      chain.reorder(Arel.sql sql)
    end

    def to_sql
      [table_column, @op, ' ', @order].compact.join
    end

    def table
      active_admin_config.resource_column_names.include?(@column) ? active_admin_config.resource_table_name : nil
    end

    def table_column
      (@column =~ /\./) ? @column :
        [table, active_admin_config.resource_quoted_column_name(@column)].compact.join(".")
    end

    def sql
      custom_sql || to_sql
    end

    protected

    def custom_sql
      if active_admin_config.ordering[@column].present?
        active_admin_config.ordering[@column].call(self)
      end
    end

  end
end
