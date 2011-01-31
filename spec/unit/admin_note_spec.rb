require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::AdminNotes::Note do

  describe "Associations and Validations" do
    it { should belong_to :resource }

    it { should validate_presence_of :resource_id }
    it { should validate_presence_of :resource_type }
    it { should validate_presence_of :body }
  end

end
