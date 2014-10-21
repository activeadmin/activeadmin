require 'rails_helper'

describe ActiveAdmin::ViewHelpers::BlankSlateHelper do
  let(:view)    { action_view }
  let(:context) { 'Plain text' }

  context '#blank_slate' do
    it 'calls ActiveAdmin::Views::BlankSlate#blank_slate with context' do
      expect_any_instance_of(ActiveAdmin::Views::BlankSlate).to receive(:blank_slate).with(context)
      view.blank_slate(context)
    end
  end

end
