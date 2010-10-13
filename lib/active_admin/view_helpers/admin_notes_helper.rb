module ActiveAdmin
  module ViewHelpers
    module AdminNotesHelper

      def admin_notes_for(resource)
        content_tag(:div, :class => "admin_notes section") do
          heading = content_tag(:h3) do
            "Admin Notes " + 
              content_tag(:span, "(#{resource.admin_notes.count})")
          end
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
          heading + notes + admin_note_form_for(resource)
        end
      end
      
      def admin_note(note)
        content_tag_for(:li, note) do
          content_tag(:h4, "Posted at #{l note.created_at}") +
            simple_format(note.body)
        end
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
