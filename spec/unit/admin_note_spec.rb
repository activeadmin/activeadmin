require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveAdmin::AdminNote do

  describe "Associations and Validations" do
    subject { ActiveAdmin::AdminNote.new }
    it { should belong_to :entity }
    it { should belong_to :admin_user }

    it { should validate_presence_of :entity_id }
    it { should validate_presence_of :entity_type }
    it { should validate_presence_of :body }

  end

end