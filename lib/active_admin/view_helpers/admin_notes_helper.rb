module ActiveAdmin
  module ViewHelpers
    module AdminNotesHelper

      def admin_notes_for(resource)
        render ActiveAdmin::AdminNotes::NotesForRenderer, resource
      end
      
      def admin_note(note)
        render ActiveAdmin::AdminNotes::NoteRenderer, note
      end
      
      def admin_note_form_for(resource)
        render ActiveAdmin::AdminNotes::FormForRenderer, resource
      end

    end
  end
end
