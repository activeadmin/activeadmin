module ActiveAdmin
  class Resource
    module Menu

      # Set the menu options. To not add this resource to the menu, just
      # call #menu(false)
      def menu(options = {})
        if options == false
          @display_menu = false
        else
          @parent  = options.delete(:parent)
          @options = options
        end
      end

      def menu_item
        @menu_item ||= MenuItem.new default_menu_options.merge(@options)
      end

      # Properly formats settings to build a parent MenuItem during registration.
      # The +parent+ option accepts either a string or a hash with other options:
      # #menu 'Child', :parent => { :label => 'Parent', :priority => 3,
      # #                           :url => 'wherever', :id => '...?' }
      def parent_menu_item
        case @parent
        when String, Proc
          { :label => @parent, :url => '#' }
        when Hash
          { :label    => @parent[:label],
            :priority => @parent[:priority],
            :url      => @parent[:url],
            :id       => @parent[:id]
          }.delete_if{ |_,val| val.nil? }
        end
      end

      # The default menu options to pass through to MenuItem.new
      def default_menu_options
        {
          :id    => resource_name.plural,
          :label => proc{ plural_resource_label },
          :url   => route_collection_path
        }
      end

      # Should this resource be added to the menu system?
      def include_in_menu?
        @display_menu != false
      end
    end
  end
end
