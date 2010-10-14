module ActiveAdmin
  module AdminNotes

    autoload :Note,             'active_admin/admin_notes/note'
    autoload :NotesController,  'active_admin/admin_notes/notes_controller'
    autoload :NotesForRenderer, 'active_admin/admin_notes/notes_for_renderer'
    autoload :NoteRenderer,     'active_admin/admin_notes/note_renderer'

  end
end
