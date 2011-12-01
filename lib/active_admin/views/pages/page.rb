module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def main_content
          page_config = active_admin_config.get_page_config(:index)

          if page_config && page_config.block
            instance_exec &page_config.block
          else
            nil
          end
        end

        protected

        def title
          active_admin_config.name
        end
      end
    end
  end
end
