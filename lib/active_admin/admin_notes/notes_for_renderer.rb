module ActiveAdmin
  module AdminNotes

    # Renders the entire section for admin notes
    #
    # To render, a view helper is provided:
    #
    #   <%= admin_notes_for @post %>
    class NotesForRenderer < Renderer

      def to_html(resource)
        @resource = resource
        admin_notes_section
      end

      private

      def admin_notes_section
        content_tag(:div, :class => "admin_notes section") do
          heading + notes + admin_note_form
        end
      end

      def heading
        content_tag(:h3) do
          "Admin Notes " + 
            content_tag(:span, "(#{resource.admin_notes.count})")
        end
      end

      def notes
        notes = content_tag(:ul, :class => "admin_notes_list") do
          if resource.admin_notes.count > 0
            resource.admin_notes.collect do |note|
              admin_note(note)
            end.join
          else
            content_tag(:li, :class => "empty") do
              content_tag(:h4, "No admin notes yet for this #{resource.class.to_s.downcase}")
            end
          end
        end
      end

      def admin_note_form
        admin_note_form_for(@resource)
      end

    end
  end
end
