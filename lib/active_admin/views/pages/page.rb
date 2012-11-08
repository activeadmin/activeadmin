module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def main_content
          if page_presenter.block
            instance_exec &page_presenter.block
          else
            nil
          end
        end

        protected

        def page_presenter
          active_admin_config.get_page_presenter(:index) || ActiveAdmin::PagePresenter.new
        end

        def title
          if page_presenter[:title]
            render_or_call_method_or_proc_on self, page_presenter[:title]
          else
            active_admin_config.name
          end
        end
      end
    end
  end
end
