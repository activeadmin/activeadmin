module ActiveAdmin
  module SoftDelete
    module DSL
      # Add soft delete actions to resource.
      # @raise When Use a gem not compatible acts_as_paranoid.
      #
      # @param options [Hash] options.
      # @option options [Boolean] :scopes      (true) create scopes of soft_delete.(need `with_deleted` and `only_deleted` scope.)
      # @option options [Boolean] :soft_delete (true) create action of soft_delete.
      # @option options [Boolean] :restore     (true) create action of restore.
      # @option options [Boolean] :hard_delete (true) create action of hard_delete.
      #
      # @yield [action, resource] If you don't use a compatible acts_as_paranoid.
      # @yieldparam [Symbol]             action    action name (:soft_delete or :restore or :hard_delete).
      # @yieldparam [ActiveRecord::Base] resource  target resource.
      #
      # @example If you don't use a compatible acts_as_paranoid. (current paranoia)
      #  soft_delete do |action, resource|
      #    case action
      #      when :soft_delete
      #        resource.destroy
      #      when :restore
      #        resource.restore
      #      when :hard_delete
      #        resource.really_destroy!
      #    end
      #  end
      def soft_delete(options = {})
        check_acts_as_paranoid! unless block_given?

        options = {
          scopes:      true,
          soft_delete: true,
          restore:     true,
        }.merge(options)

        if options[:scopes]
          scope :only_deleted # only soft_deleted records.
          include_soft_deleted_records_in_default_scope
        end

        if options[:soft_delete]
          add_member_and_batch_action :soft_delete, :method => :delete do |resource|
            block_given? ? yield(:soft_delete, resource) : resource.destroy
          end
        end

        if options[:restore]
          add_member_and_batch_action :restore, :method => :put do |resource|
            block_given? ? yield(:restore, resource) : resource.recover
          end
        end

        add_member_and_batch_action :destroy, :method => :delete, :preterit => 'destroyed' do |resource|
          block_given? ? yield(:hard_delete, resource) : resource.destroy!
        end
      end

      private
      # Add member_action and batch_action.
      # @raise When yield block is nothing.
      #
      # @param name    [Symbol] name of member and batch_action.
      # @param options [Hash]   options.
      # @option options [Symbol] :method    (:get)       HTTP Method.
      # @option options [String] :preterit  ("#{name}d") preterit name.
      #
      # @yield [resource] action.
      # @yieldparam [ActiveRecord::Base] resource target resource.
      def add_member_and_batch_action(name, options = {})
        raise 'yield block is nothing.' unless block_given?

        options = {
          method:   :get,
          preterit: "#{name}d"
        }.merge(options)

        batch_options = {
          priority: 100,
          confirm:  proc{ I18n.t("active_admin.batch_actions.#{name}_confirmation") },
          if:       proc{ authorized?(name, active_admin_config.resource_class) }
        }

        member_action name, :method => options[:method] do
          yield resource
          redirect_to active_admin_config.route_collection_path(params),
                      :notice => I18n.t("active_admin.actions.succesfully_#{options[:preterit]}")
        end

        batch_action name, batch_options do |selected_ids|
          active_admin_config.resource_class.find(selected_ids).each{ |resource| yield resource }
          redirect_to active_admin_config.route_collection_path(params),
              :notice => I18n.t("active_admin.batch_actions.succesfully_#{options[:preterit]}",
                  :count => selected_ids.count,
                  :model => active_admin_config.resource_label.downcase,
                  :plural_model => active_admin_config.plural_resource_label(:count => selected_ids.count).downcase)
        end
      end

      # Check if acts_as_paranoid
      # @raise resource is not acts_as_paranoid.
      def check_acts_as_paranoid!
        unless @resource.respond_to?(:paranoid?) and @resource.paranoid?
          raise 'This resource is not acts_as_paranoid.'
        end
      end

      # Include soft deleted records in scope.
      def include_soft_deleted_records_in_default_scope
        controller do
          def scoped_collection
            super.with_deleted
          end
        end
      end
    end
  end

  # Add extension.
  ActiveAdmin::ResourceDSL.send :include, ActiveAdmin::SoftDelete::DSL
end
