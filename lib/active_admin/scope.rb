# frozen_string_literal: true
module ActiveAdmin
  class Scope

    attr_reader :scope_method, :id, :scope_block, :display_if_block, :show_count, :default_block, :group

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
    #   Scope.new 'Published', :public, if: proc { current_admin_user.can? :manage, resource_class } do |articles|
    #     articles.where published: true
    #   end
    #   # => Scope with name 'Published' and scope method :public, optionally displaying the scope per the :if block
    #
    #   Scope.new('Published') { |articles| articles.where(published: true) }
    #   # => Scope with name 'Published' using a block to scope
    #
    #   Scope.new ->{Date.today.strftime '%A'}, :published_today
    #   # => Scope with dynamic title using the :published_today scope method
    #
    #   Scope.new :published, nil, group: :status
    #   # => Scope with the group :status
    #
    def initialize(name, method = nil, options = {}, &block)
      @name = name
      @scope_method = method.try(:to_sym)

      if name.is_a? Proc
        raise "A string/symbol is required as the second argument if your label is a proc." unless method
        @id = method.to_s.parameterize(separator: "_")
      else
        @scope_method ||= name.to_sym
        @id = name.to_s.parameterize(separator: "_")
      end

      @scope_method = nil if @scope_method == :all
      if block_given?
        @scope_method = nil
        @scope_block = block
      end

      @localizer = options[:localizer]
      @show_count = options.fetch(:show_count, true)
      @display_if_block = options[:if] || proc { true }
      @default_block = options[:default] || proc { false }
      @group = options[:group].try(:to_sym)
    end

    def name
      case @name
      when String then @name
      when Symbol then @localizer ? @localizer.t(@name, scope: "scopes") : @name.to_s.titleize
      else @name
      end
    end

  end
end
