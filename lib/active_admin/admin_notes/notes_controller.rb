module ActiveAdmin
  module AdminNotes
    class NotesController < ResourceController

      defaults :resource_class => ActiveAdmin::AdminNotes::Note
      actions :create
      
      def create
        @admin_note = Note.new(params[:admin_note])
                          
        if current_active_admin_user?
         assign_admin_note_to_current_admin_user(@admin_note)
        end
              
        if @admin_note.save
          respond_to do |format|
            format.js { render :json => {:note => self.class.helpers.admin_note(@admin_note),
                                         :number_of_notes => @admin_note.resource.admin_notes.count}.to_json, :status => 200 }
          end
        else
          respond_to do |format|
            format.json { render :json => @admin_note.errors.full_messages, :status => :precondition_failed }
          end
        end
      end
      
      def add_section_breadcrumb; end
      def set_current_tab; end
      
      private
      
      def assign_admin_note_to_current_admin_user(admin_note)
        admin_note.admin_user = current_active_admin_user
      end
      
    end
  end
end
