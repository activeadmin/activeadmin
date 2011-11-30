module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def main_content
          if index_config && index_config.block
            instance_exec &index_config.block
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
