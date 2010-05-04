module ActiveAdmin
  module Breadcrumbs
    
    def self.included(base)
      base.send :extend, ClassMethods
    end
      
    protected

    def add_breadcrumb(name, url = '')
      @breadcrumbs ||= []
      url = send(url) if url.is_a?(Symbol)
      @breadcrumbs << [name, url]
    end

    module ClassMethods

      def add_breadcrumb(name, url, options = {})
        before_filter options do |controller|
          controller.send(:add_breadcrumb, name, url)
        end
      end
    
    end
  end
end
