module ActiveAdmin
  class Scope

    attr_reader :name, :scope_method, :id, :scope_block

    # Create a Scope
    #
    # Examples:
    #
    #   Scope.new(:published)
    #   # => Scope with name 'Published' and scope method :published
    #
    #   Scope.new('Published', :public)
    #   # => Scope with name 'Published' and scope method :public
    #
    #   Scope.new('Published') { |articles| articles.where(:published => true) }
    #   # => Scope with name 'Published' using a block to scope
    #
    def initialize(name, method = nil, &block)
      @name = name.to_s.titleize
      @scope_method = method
      # Scope ':all' means no scoping
      @scope_method ||= name.to_sym unless name.to_sym == :all
      @id = @name.gsub(' ', '').underscore
      if block_given?
        @scope_method = nil
        @scope_block = block
      end
    end
  end
end
