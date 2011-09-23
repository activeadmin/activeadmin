module ActiveAdmin
  module Views
    module Pages
      class Show < Base

        def config
          active_admin_config.page_configs[:show] || ::ActiveAdmin::PageConfig.new
        end

        def title
          case config[:title]
          when Symbol, Proc
            call_method_or_proc_on(resource, config[:title])
          when String
            config[:title]
          else
            default_title
          end
        end

        def main_content
          if config.block
            # Eval the show config from the controller
            instance_exec resource, &config.block
          else
            default_main_content
          end
        end

        def attributes_table(*args, &block)
          panel(I18n.t('active_admin.details', :model => active_admin_config.resource_name)) do
            attributes_table_for resource, *args, &block
          end
        end

        protected

        # If #to_s is defined on the resource, use it for the title. Otherwise
        # show the resource name and it's id.
        def default_title
          # Object#to_s returns something like this:
          # => "#<Object:0x007fa1d454b1e0>"
          if resource.to_s.starts_with? '#<'
            "#{active_admin_config.resource_name} ##{resource.id}"
          else
            resource.to_s
          end
        end

        module DefaultMainContent
          def default_main_content
            attributes_table *default_attribute_table_rows
          end

          def default_attribute_table_rows
            resource.class.columns.collect{|column| column.name.to_sym }
          end
        end

        include DefaultMainContent
      end
    end
  end
end
