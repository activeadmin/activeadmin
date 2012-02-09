require 'active_admin/arbre/html/element'

module Arbre
  class Context < Arbre::HTML::Element
    def indent_level
      # A context does not increment the indent_level
      super - 1
    end

    def bytesize
      cached_html.bytesize
    end
    alias :length :bytesize

    def respond_to?(method)
      super || cached_html.respond_to?(method)
    end

    # Webservers treat Arbre::Context as a string. We override
    # method_missing to delegate to the string representation
    # of the html.
    def method_missing(method, *args, &block)
      if cached_html.respond_to? method
        cached_html.send method, *args, &block
      else
        super
      end
    end

    private

    # Caches the rendered HTML so that we don't re-render just to
    # get the content lenght or to delegate a method to the HTML
    def cached_html
      if defined?(@cached_html)
        @cached_html
      else
        html = to_s
        @cached_html = html if html.length > 0
        html
      end
    end

  end
end
