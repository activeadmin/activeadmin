require 'rails_helper'

describe ActiveAdmin::ViewHelpers::StatusTagHelper do
  let(:view) { action_view }
  let(:args) { ['active', :ok, class: 'important', id: 'status_123', label: 'on'] }

  context '#status_tag' do
    it 'calls ActiveAdmin::Views::StatusTag#status_tag with arguments' do
      expect_any_instance_of(ActiveAdmin::Views::StatusTag).to receive(:status_tag).with(*args)
      view.status_tag(*args)
    end
  end

end
