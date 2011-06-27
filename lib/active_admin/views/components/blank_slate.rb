module ActiveAdmin
  module Views
    # Build a Blank Slate
    class BlankSlate < ActiveAdmin::Component
      builder_method :blank_slate
      
      def default_class_name
        'blank_slate_container'
      end
      
      def build(name, url = nil)
        if url
          super(span(blank_slate_content_with_link(name, url), :class => "blank_slate"))
        else
          super(span(blank_slate_content_without_link(name), :class => "blank_slate"))
        end
      end
      
      private
      
      def blank_slate_content_with_link(name, url)
        I18n.t('active_admin.blank_slate.content', :resource_name => name).html_safe +
          " " +
            link_to(I18n.t('active_admin.blank_slate.link').html_safe, url)
      end
      
      def blank_slate_content_without_link(name)
        I18n.t('active_admin.blank_slate.content', :resource_name => name).html_safe
      end
      
    end
  end
end