module ActiveAdmin
  module Views
    module Pages
      class Page < Base

        def main_content
          instance_exec &index_config.block
        end

        protected

        # Pages don't have sidebars
        def build_sidebar; end

        def build_action_items; end

        def sidebar_sections_for_action; end

        def skip_sidebar?; true; end

        def title
          config.name
        end

      end
    end
  end
end
