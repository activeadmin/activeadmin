# frozen_string_literal: true
module ActiveAdmin
  class AbstractViewFactory < SettingsNode

    def self.register(view_hash)
      view_hash.each do |view_key, view_class|
        super view_key, view_class
        add_writer(view_key)
        send "#{view_key}=", view_class
      end
    end

    def self.add_writer(name)
      define_singleton_method("#{name}=") do |value|
        value.builder_method name
        instance_variable_set :"@#{name}", value
      end
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
      self.class.register view_hash
    end

    def default_for(key)
      self.class.send key
    end

    def [](key)
      send key
    end

    def []=(key, value)
      send "#{key}=", value
    end
  end
end
