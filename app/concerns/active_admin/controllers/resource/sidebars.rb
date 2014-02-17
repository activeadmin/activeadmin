module ActiveAdmin
  module Controllers
    module Resource

      module Sidebars
        protected

        def skip_sidebar!
          @skip_sidebar = true
        end

        def skip_sidebar?
          @skip_sidebar == true
        end
      end

    end
  end
end
