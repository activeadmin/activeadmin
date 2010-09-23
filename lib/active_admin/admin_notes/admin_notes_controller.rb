module ActiveAdmin
  class AdminNotesController < ResourceController
    
    actions :create
    
    def create
      @admin_note = AdminNote.new(params[:active_admin_admin_note])
            
      if @admin_note.save
        respond_to do |format|
          format.js { render :json => {:note => self.class.helpers.admin_note(@admin_note),
                                       :number_of_notes => @admin_note.entity.admin_notes.count}.to_json,
                                       :status => 200 }
        end
      else
        respond_to do |format|
          format.json { render :json => @admin_note.errors.full_messages, :status => :precondition_failed }
        end
      end
    end
    
    def add_section_breadcrumb; end
    def set_current_tab; end
  end
end