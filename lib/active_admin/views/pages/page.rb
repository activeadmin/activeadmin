module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def main_content
          instance_exec &index_config.block
        end

        protected

        def title
          active_admin_config.name
        end
      end
    end
  end
end
