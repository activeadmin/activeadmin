module ActiveAdmin
  module ViewHelpers
    module IconHelper

      # Render an icon from the Iconic icon set
      def icon(*args)
        ActiveAdmin::Iconic.icon(*args)
      end

    end
  end
end
