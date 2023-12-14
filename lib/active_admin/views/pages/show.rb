# frozen_string_literal: true
module ActiveAdmin
  module Views
    module Pages
      class Show < Arbre::Element
        def build(*args)
          set_page_title(title)
          div class: "main-content-container" do
            main_content
          end
        end

        delegate :active_admin_config, :controller, :params, to: :helpers

        def config
          active_admin_config.get_page_presenter(:show) || ActiveSupport::OrderedOptions.new
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
          attributes_table_for resource, *args, &block
        end

        protected

        def default_title
          display_name(resource)
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
