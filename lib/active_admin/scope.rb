module ActiveAdmin
  class Scope

    attr_reader :name, :scope_method, :id, :scope_block

    def initialize(name, method = nil, &block)
      @name = name.to_s.titleize
      @scope_method = method || name.to_sym
      @id = @name.gsub(' ', '').underscore
      if block_given?
        @scope_method = nil
        @scope_block = block
      end
    end

  end
end
