module ActiveAdmin
  module Views
    module Pages
      class Exception < Base

        def main_content
        end

        protected

        def title
          "Error #{status}"
        end
      end
    end
  end
end
