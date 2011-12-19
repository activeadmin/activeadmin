module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def main_content
          page_presenter = active_admin_config.get_page_presenter(:index)

          if page_presenter && page_presenter.block
            instance_exec &page_presenter.block
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
