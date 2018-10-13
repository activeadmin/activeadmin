require 'rails_helper'
require 'active_admin/batch_actions/views/batch_action_selector'

RSpec.describe ActiveAdmin::BatchActions::BatchActionSelector do

  let(:dropdown) do
    render_arbre_component do
      batch_action_selector [
        ActiveAdmin::BatchAction.new(:action_1, "Action 1"),
        ActiveAdmin::BatchAction.new(:action_2, "Action 2"),
        ActiveAdmin::BatchAction.new(:action_3, "Action 3")
      ]
    end
  end

  describe "the action list" do
    subject do
      dropdown.find_by_class("dropdown_menu_list").first
    end

    describe '#tag_name' do
      subject { super().tag_name }
      it { is_expected.to eql("ul") }
    end

    describe '#content' do
      subject { super().content }
      it{ is_expected.to include("class=\"batch_action\" data-action=\"action_1\"") }
    end

    describe '#content' do
      subject { super().content }
      it{ is_expected.to include("class=\"batch_action\" data-action=\"action_2\"") }
    end

    describe '#content' do
      subject { super().content }
      it{ is_expected.to include("class=\"batch_action\" data-action=\"action_3\"") }
    end

  end

end
