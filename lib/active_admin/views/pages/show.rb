module ActiveAdmin
  module Views
    module Pages
      class Show < Base

        def config
          active_admin_config.get_page_presenter(:show) || super
        end

        def title
          if config[:title]
            render_or_call_method_or_proc_on(resource, config[:title])
          else
            assigns[:page_title] || default_title
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
          opts = args.extract_options!
          table_title = if opts.has_key?(:title)
                          render_or_call_method_or_proc_on(resource, opts[:title])
                        else
                          ActiveAdmin::Localizers.resource(active_admin_config).t(:details)
                        end
          panel(table_title) do
            attributes_table_for resource, *args, &block
          end
        end

        protected

        def default_title
          title = display_name(resource)

          if title.blank?
            title = "#{active_admin_config.resource_label} ##{resource.id}"
          end

          title
        end

        module DefaultMainContent
          def default_main_content(&block)
            attributes_table(*default_attribute_table_rows, &block)
          end

          def default_attribute_table_rows
            active_admin_config.resource_columns
          end
        end

        include DefaultMainContent
      end
    end
  end
end
