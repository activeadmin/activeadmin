require 'rails_helper'

describe ActiveAdmin::ViewHelpers::PanelHelper do
  let(:view)        { action_view }
  let(:title)       { 'Panel title' }
  let(:attributes)  { {} }

  context '#panel' do
    it 'calls ActiveAdmin::Views::Panel#panel with title and attributes' do
      expect_any_instance_of(ActiveAdmin::Views::Panel).to receive(:panel).with(title, attributes)
      view.panel(title, attributes)
    end
  end

end
