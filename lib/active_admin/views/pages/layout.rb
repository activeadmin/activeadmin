module ActiveAdmin
  module Views
    module Pages

      # Acts as a standard rails Layout for use when logged
      # out or when rendering custom actions.
      class Layout < Base

        def title
          assigns[:page_title] || I18n.t("active_admin.#{params[:action]}", default: params[:action].to_s.titleize)
        end

        # Render the content_for(:layout) into the main content area
        def main_content
          content_for_layout = content_for(:layout)
          if content_for_layout.is_a?(Arbre::Element)
            current_arbre_element.add_child content_for_layout.children
          else
            text_node content_for_layout
          end
        end
      end

    end
  end
end
