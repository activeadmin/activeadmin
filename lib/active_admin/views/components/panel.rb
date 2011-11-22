module ActiveAdmin
  module Views

    class Panel < ActiveAdmin::Component
      builder_method :panel

      def build(title, attributes = {})
        icon_name = attributes.delete(:icon)
        icn = icon_name ? icon(icon_name) : ""        
        super(attributes)
        add_class "panel"
        if attributes.include? :toggle
          
          if attributes[:toggle].is_a?( Hash )
            
            add_class "toggle" 
            if attributes[:toggle].include?( :show )                            
              boolean_or_proc = attributes[:toggle][:show]
              case boolean_or_proc
              when Proc
                add_class "on" if controller.instance_exec(&boolean_or_proc)
              else
                add_class "on"if boolean_or_proc
              end
            end
            
          elsif attributes[:toggle]
            add_class "toggle" 
          end
          
        end
        @title = h3(icn + title.to_s)
        @contents = div(:class => "panel_contents")
      end

      def add_child(child)
        if @contents
          @contents << child
        else
          super
        end
      end
    end

  end
end
