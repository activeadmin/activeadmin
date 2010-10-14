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
        loader = content_tag(:div, :class => "loading_indicator", :style => "display: none") do
          image_tag("active_admin/loading.gif", :size => "16x16") +
            content_tag(:span, "Adding note...")
        end
          
        form = active_admin_form_for(ActiveAdmin::AdminNotes::Note.new, :as => :admin_note, :url => admin_admin_notes_path, :html => {:class => "inline_form"}) do |form|
          form.inputs do
            form.input :resource_type, :value => resource.class.to_s, :as => :hidden
            form.input :resource_id, :value => resource.id, :as => :hidden
            form.input :body, :input_html => {:size => "80x12"}, :label => false
          end
          form.buttons do
            form.commit_button 'Add note'
          end
        end
        loader + form
      end

    end
  end
end
