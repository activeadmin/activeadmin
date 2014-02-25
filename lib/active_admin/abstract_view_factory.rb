module ActiveAdmin
  class AbstractViewFactory
    @@default_views = {}

    def self.register(view_hash)
      view_hash.each do |view_key, view_class|
        @@default_views[view_key] = view_class
      end
    end

    def initialize
      @views = {}
    end

    # Register a new view key with the view factory
    #
    # eg:
    #
    #   factory = AbstractViewFactory.new
    #   factory.register my_view: SomeViewClass
    #
    # You can setup many at the same time:
    #
    #   factory.register  my_view: SomeClass,
    #                     another_view: OtherViewClass
    #
    def register(view_hash)
      view_hash.each do |view_key, view_class|
        @views[view_key] = view_class
      end
    end

    def default_for(key)
      @@default_views[key.to_sym]
    end

    def has_key?(key)
      @views.has_key?(key.to_sym) || @@default_views.has_key?(key.to_sym)
    end

    def [](key)
      get_view_for_key(key)
    end

    def []=(key, value)
      set_view_for_key(key, value)
    end

    # Override respond to to include keys
    def respond_to?(method)
      key = key_from_method_name(method)
      if has_key?(key)
        true
      else
        super
      end
    end

    private

    def method_missing(method, *args)
      key = key_from_method_name(method)
      if has_key?(key)
        if method.to_s.include?('=')
          set_view_for_key key, args.first
        else
          get_view_for_key key
        end
      else
        super
      end
    end

    def key_from_method_name(method)
      method.to_s.gsub('=', '').to_sym
    end

    def get_view_for_key(key)
      @views[key.to_sym] || @@default_views[key.to_sym]
    end

    def set_view_for_key(key, view)
      @views[key.to_sym] = view
    end
  end
end
