module ActiveAdmin
  module AdminNotes

    autoload :Note,                 'active_admin/admin_notes/note'
    autoload :NotesController,      'active_admin/admin_notes/notes_controller'
    autoload :NotesForRenderer,     'active_admin/admin_notes/renderers'
    autoload :NoteRenderer,         'active_admin/admin_notes/renderers'
    autoload :FormForRenderer,      'active_admin/admin_notes/renderers'

  end
end
