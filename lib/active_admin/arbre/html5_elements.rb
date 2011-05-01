module Arbre
  module HTML

    AUTO_BUILD_ELEMENTS = [ :a, :abbr, :address, :area, :article, :aside, :audio, :b, :base,
                       :bdo, :blockquote, :body, :br, :button, :canvas, :caption, :cite,
                       :code, :col, :colgroup, :command, :datalist, :dd, :del, :details,
                       :dfn, :div, :dl, :dt, :em, :embed, :fieldset, :figcaption, :figure,
                       :footer, :form, :h1, :h2, :h3, :h4, :h5, :h6, :head, :header, :hgroup, 
                       :hr, :html, :i, :iframe, :img, :input, :ins, :keygen, :kbd, :label, 
                       :legend, :li, :link, :map, :mark, :menu, :meta, :meter, :nav, :noscript, 
                       :object, :ol, :optgroup, :option, :output, :pre, :progress, :q,
                       :s, :samp, :script, :section, :select, :small, :source, :span,
                       :strong, :style, :sub, :summary, :sup, :table, :tbody, :td,
                       :textarea, :tfoot, :th, :thead, :time, :title, :tr, :ul, :var, :video ]

    HTML5_ELEMENTS = [ :p ] + AUTO_BUILD_ELEMENTS

    AUTO_BUILD_ELEMENTS.each do |name|
      class_eval <<-EOF
        class #{name.to_s.capitalize} < Tag
          builder_method :#{name}
        end
      EOF
    end

    class P < Tag
      builder_method :para
    end

    class Table < Tag
      def initialize(*)
        super
        set_table_tag_defaults
      end

      protected

      # Set some good defaults for tables
      def set_table_tag_defaults
        set_attribute :border,      0
        set_attribute :cellspacing, 0
        set_attribute :cellpadding, 0
      end
    end

  end
end
