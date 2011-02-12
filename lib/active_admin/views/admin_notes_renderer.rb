module ActiveAdmin
  module Views

    # Renders the entire section for admin notes
    #
    #   <%= render view_factory.admin_notes, @post %>
    class AdminNotesRenderer < ActiveAdmin::Renderer

      def to_html(resource)
        @resource = resource
        admin_notes_section
      end

      private

      def admin_notes_section
        content_tag(:div, :class => "admin_notes section") do
          heading + notes + ajax_loader + admin_note_form
        end
      end

      def heading
        content_tag(:h3) do
          icon(:chat_alt_stroke) + "Admin Notes " + 
            content_tag(:span, "(#{resource.admin_notes.count})", :class => "admin_notes_count")
        end
      end

      def notes
        notes = content_tag(:ul, :class => "admin_notes_list") do
          if resource.admin_notes.count > 0
            resource.admin_notes.collect do |note|
              admin_note(note)
            end.join.html_safe
          else
            content_tag(:li, :class => "empty") do
              content_tag(:h4, "No admin notes yet for this #{resource.class.to_s.downcase}")
            end
          end
        end
      end

      def admin_note(note)
        content_tag_for(:li, note) do
          note_title(note) + note_body(note)
        end
      end

      def note_title(note)
        content_tag(:h4, "Posted at #{l note.created_at}")
      end

      def note_body(note)
        simple_format(note.body)
      end

      def ajax_loader
        content_tag(:div, :class => "loading_indicator", :style => "display: none") do
          image_tag("active_admin/loading.gif", :size => "16x16") + content_tag(:span, "Adding note...")
        end
      end

      def admin_note_form
        active_admin_form_for(ActiveAdmin::AdminNotes::Note.new, :as => :admin_note, :url => admin_admin_notes_path, :html => {:class => "inline_form"}) do |form|
          form.inputs do
            form.input :resource_type, :value => @resource.class.base_class.name.to_s, :as => :hidden
            form.input :resource_id, :value => @resource.id, :as => :hidden
            form.input :body, :input_html => {:size => "80x8"}, :label => false
          end
          form.buttons do
            form.commit_button 'Add Note'
          end
        end
      end

    end
  end
end
