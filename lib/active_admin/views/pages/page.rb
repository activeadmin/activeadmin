module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def config
          active_admin_config.get_page_presenter(:index) || ::ActiveAdmin::PagePresenter.new
        end

        def main_content
          if config.block
            instance_exec &config.block
          else
            nil
          end
        end

        protected

        def title
          if config[:title]
            render_or_call_method_or_proc_on self, config[:title]
          else
            active_admin_config.name
          end
        end
      end
    end
  end
end
