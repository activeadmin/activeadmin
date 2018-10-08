require_relative 'components/menu'

module ActiveAdmin
  module Views
    class TabbedNavigation < Menu
      def build(menu, options = {})
        super(menu, options.reverse_merge(id: 'tabs'))
      end
    end
  end
end
