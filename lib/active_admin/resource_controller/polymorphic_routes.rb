# If we rename a resource by calling `ActiveAdmin.register Model, as: RenamedModel`,
# ActiveAdmin creates a #admin_renamed_model_path helper method.
# If we also use belongs_to inside the ActiveAdmin.register block,
# InheritedResources will call the #polymorphic_path method
# and pass "resource_class.new" as an argument.
# #resource_class is the original model class, and it doesn't know
# anything about the renamed ActiveAdmin resource.
# So when #polymorphic_path calls #model_name on the class, it returns
# the original model name (e.g. "Model", instead of "RenamedModel")
# and will end up calling #admin_model_path, instead of #admin_renamed_model_path.
# This causes an error, because #admin_model_path is not defined.
#
# This issue was solved by customizing the polymorphic routes code for Active Admin.
# We use a custom ActiveAdminHelperMethodBuilder class that is aware of
# #resource_name and #resource_class, and selects the correct model_name
# to handle any renamed resources.
#
# The original PolymorphicRoutes code can be found in:
# actionpack-5.2.1/lib/action_dispatch/routing/polymorphic_routes.rb

module ActiveAdmin
  class ResourceController < BaseController
    module PolymorphicRoutes
      extend ActiveSupport::Concern

      def polymorphic_url(record_or_hash_or_array, options = {})
        if Hash === record_or_hash_or_array
          options = record_or_hash_or_array.merge(options)
          record  = options.delete :id
          return polymorphic_url record, options
        end

        if mapping = polymorphic_mapping(record_or_hash_or_array)
          return mapping.call(self, [record_or_hash_or_array, options], false)
        end

        opts   = options.dup
        action = opts.delete :action
        type   = opts.delete(:routing_type) || :url

        ActiveAdminHelperMethodBuilder.polymorphic_method self,
                                                          active_admin_config.resource_name,
                                                          active_admin_config.resource_class,
                                                          record_or_hash_or_array,
                                                          action,
                                                          type,
                                                          opts
      end

      # Returns the path component of a URL for the given record. It uses
      # <tt>polymorphic_url</tt> with <tt>routing_type: :path</tt>.
      def polymorphic_path(record_or_hash_or_array, options = {})
        if Hash === record_or_hash_or_array
          options = record_or_hash_or_array.merge(options)
          record  = options.delete :id
          return polymorphic_path record, options
        end

        if mapping = polymorphic_mapping(record_or_hash_or_array)
          return mapping.call(self, [record_or_hash_or_array, options], true)
        end

        opts   = options.dup
        action = opts.delete :action
        type   = :path

        ActiveAdminHelperMethodBuilder.polymorphic_method self,
                                                          active_admin_config.resource_name,
                                                          active_admin_config.resource_class,
                                                          record_or_hash_or_array,
                                                          action,
                                                          type,
                                                          opts
      end

      private

      class ActiveAdminHelperMethodBuilder # :nodoc:
        CACHE = { "path" => {}, "url" => {} }

        def self.get(action, type)
          type = type.to_s
          CACHE[type].fetch(action) { build action, type }
        end

        def self.url;  CACHE["url".freeze][nil]; end
        def self.path; CACHE["path".freeze][nil]; end

        def self.build(action, type)
          prefix = action ? "#{action}_" : ""
          suffix = type
          if action.to_s == "new"
            ActiveAdminHelperMethodBuilder.singular prefix, suffix
          else
            ActiveAdminHelperMethodBuilder.plural prefix, suffix
          end
        end

        def self.singular(prefix, suffix)
          new(->(name) { name.singular_route_key }, prefix, suffix)
        end

        def self.plural(prefix, suffix)
          new(->(name) { name.route_key }, prefix, suffix)
        end

        def self.polymorphic_method(recipient, resource_name, resource_class, record_or_hash_or_array, action, type, options)
          builder = get action, type

          case record_or_hash_or_array
          when Array
            record_or_hash_or_array = record_or_hash_or_array.compact
            if record_or_hash_or_array.empty?
              raise ArgumentError, "Nil location provided. Can't build URI."
            end
            if record_or_hash_or_array.first.is_a?(ActionDispatch::Routing::RoutesProxy)
              recipient = record_or_hash_or_array.shift
            end

            method, args = builder.handle_list(
              record_or_hash_or_array, resource_name, resource_class)
          when String, Symbol
            method, args = builder.handle_string record_or_hash_or_array
          when Class
            method, args = builder.handle_class(
              record_or_hash_or_array, resource_name, resource_class)

          when nil
            raise ArgumentError, "Nil location provided. Can't build URI."
          else
            method, args = builder.handle_model(
              record_or_hash_or_array, resource_name, resource_class)
          end

          if options.empty?
            recipient.send(method, *args)
          else
            recipient.send(method, *args, options)
          end
        end

        attr_reader :suffix, :prefix

        def initialize(key_strategy, prefix, suffix)
          @key_strategy = key_strategy
          @prefix       = prefix
          @suffix       = suffix
        end

        def handle_string(record)
          [get_method_for_string(record), []]
        end

        def handle_string_call(target, str)
          target.send get_method_for_string str
        end

        def handle_class(klass, resource_name, resource_class)
          [get_method_for_class(klass, resource_name, resource_class), []]
        end

        def handle_class_call(target, klass)
          target.send get_method_for_class klass
        end

        def handle_model(record, resource_name, resource_class)
          args  = []

          model = record.to_model
          named_route =
            if model.persisted?
              args << model
              model_name = model.is_a?(resource_class) ? resource_name : model.model_name
              get_method_for_string model_name.singular_route_key
            else
              get_method_for_class model
            end

          [named_route, args]
        end

        def handle_model_call(target, record)
          if mapping = polymorphic_mapping(target, record)
            mapping.call(target, [record], suffix == "path")
          else
            method, args = handle_model(record)
            target.send(method, *args)
          end
        end

        def handle_list(list, resource_name, resource_class)
          record_list = list.dup
          record      = record_list.pop

          args = []

          route = record_list.map { |parent|
            case parent
            when Symbol, String
              parent.to_s
            when Class
              args << parent
              model_name = parent == resource_class ? resource_name : parent.model_name
              model_name.singular_route_key
            else
              model = parent.to_model
              args << model
              model_name = parent.is_a?(resource_class) ? resource_name : model.model_name
              model_name.singular_route_key
            end
          }

          route <<
          case record
          when Symbol, String
            record.to_s
          when Class
            model_name = record == resource_class ? resource_name : record.model_name
            @key_strategy.call model_name
          else
            model = record.to_model
            model_name = record.is_a?(resource_class) ? resource_name : record.model_name
            if model.persisted?
              args << model
              model_name.singular_route_key
            else
              @key_strategy.call model_name
            end
          end

          route << suffix

          named_route = prefix + route.join("_")
          [named_route, args]
        end

        private

        def polymorphic_mapping(target, record)
          if record.respond_to?(:to_model)
            target._routes.polymorphic_mappings[record.to_model.model_name.name]
          else
            target._routes.polymorphic_mappings[record.class.name]
          end
        end

        def get_method_for_class(klass, resource_name, resource_class)
          model_name = klass == resource_class ? resource_name : klass.model_name
          name = @key_strategy.call model_name
          get_method_for_string name
        end

        def get_method_for_string(str)
          "#{prefix}#{str}_#{suffix}"
        end

        [nil, "new", "edit"].each do |action|
          CACHE["url"][action]  = build action, "url"
          CACHE["path"][action] = build action, "path"
        end
      end
    end
  end
end
