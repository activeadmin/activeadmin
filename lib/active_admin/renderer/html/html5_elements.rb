module ActiveAdmin
  class Renderer
    module HTML

      HTML5_ELEMENTS = [ :a, :abbr, :address, :area, :article, :aside, :audio, :b, :base,
                         :bdo, :blockquote, :body, :br, :button, :canvas, :caption, :cite,
                         :code, :col, :colgroup, :command, :datalist, :dd, :del, :details,
                         :dfn, :div, :dl, :dt, :em, :embed, :fieldset, :figcaption, :figure,
                         :footer, :form, :h1, :head, :header, :hgroup, :hr, :html, :i,
                         :iframe, :img, :input, :ins, :keygen, :kbd, :label, :legend, :li,
                         :link, :map, :mark, :menu, :meta, :meter, :nav, :noscript, :object,
                         :ol, :optgroup, :option, :output, :p, :param, :pre, :progress, :q,
                         :s, :samp, :script, :section, :select, :small, :source, :span,
                         :strong, :style, :sub, :summary, :sup, :table, :tbody, :td,
                         :textarea, :tfoot, :th, :thead, :time, :title, :tr, :ul, :var, :video ]

      HTML5_ELEMENTS.each do |name|
        class_eval <<-EOF
          class #{name.to_s.capitalize} < Tag
            builder_method :#{name}
          end
        EOF
      end

    end
  end
end
