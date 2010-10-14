module ActiveAdmin
  module AdminNotes
    class NoteRenderer < Renderer

      def to_html(note)
        @note = note
        content_tag_for(:li, note) do
          title + body
        end
      end

      def title
        content_tag(:h4, "Posted at #{l @note.created_at}")
      end

      def body
        simple_format(@note.body)
      end

    end
  end
end
