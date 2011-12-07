module ActiveAdmin
  class Scope

    attr_reader :name, :scope_method, :id, :scope_block, :display_if_block

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
    #   Scope.new('Published', :public, :if => proc { current_admin_user.can?( :manage, active_admin_config.resource_class ) } ) { |articles| articles.where(:published => true) }
    #   # => Scope with name 'Published' and scope method :public, optionally displaying the scope per the :if block, using a block
    #
    #   Scope.new('Published') { |articles| articles.where(:published => true) }
    #   # => Scope with name 'Published' using a block to scope
    #
    def initialize(name, method = nil, options = {}, &block)
      @name = name.is_a?( String ) ? name : name.to_s.titleize
      @scope_method = method
      # Scope ':all' means no scoping
      @scope_method ||= name.to_sym unless name.to_sym == :all
      @id = @name.gsub(' ', '').underscore
      if block_given?
        @scope_method = nil
        @scope_block = block
      end

      @display_if_block = options[:if]
    end

    # Returns the display if block. If the block was not explicitly defined
    # a default block always returning true will be returned.
    def display_if_block
      @display_if_block || proc{ true }
    end

  end
end
