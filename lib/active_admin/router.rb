module ActiveAdmin
  class Router
    extend ActiveSupport::Autoload

    autoload :ResourceRoutes

    attr_reader :application

    def initialize(application)
      @application = application
    end

    # Creates all the necessary routes for the ActiveAdmin configurations
    #
    # Use this within the routes.rb file:
    #
    #   Application.routes.draw do |map|
    #     ActiveAdmin.routes(self)
    #   end
    #
    def apply(router)
      define_root_routes(router)
      define_resource_routes(router)
    end

    private

    def define_root_routes(router)
      router.instance_exec application.namespaces.values do |namespaces|
        namespaces.each do |namespace|
          if namespace.root?
            root to: namespace.root_to
          else
            namespace namespace.name do
              root to: namespace.root_to
            end
          end
        end
      end
    end

    # Defines the routes for each resource
    def define_resource_routes(router)
      router.instance_exec application.namespaces do |namespaces|
        resources = namespaces.values.flat_map { |n| n.resources.values }

        resources.each do |config|
          ActiveAdmin::Router::ResourceRoutes.new(router, config).call
        end
      end
    end
  end
end
