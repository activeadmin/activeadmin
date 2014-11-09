require 'rails_helper'

describe ActiveAdmin::Views::Pages::Form do
  describe "#title" do
    let!(:application){ ActiveAdmin::Application.new }
    let(:namespace){ ActiveAdmin::Namespace.new(application, "Admin") }
    let!(:params){ { controller: "UsersController", action: "edit" } }
    let(:helpers) do
      helpers = mock_action_view
      allow(helpers).to receive(:active_admin_config).and_return(namespace.register(Post))
      allow(helpers).to receive(:params).and_return(params)
      helpers
    end

    let(:arbre_context) do
      OpenStruct.new(params: params, helpers: helpers, assigns: {})
    end

    context "when page_title is assigned" do
      it "should show the set page title" do
        arbre_context.assigns[:page_title] = "My Page Title"
        page = ActiveAdmin::Views::Pages::Form.new(arbre_context)
        expect(page.title).to eq "My Page Title"
      end
    end

    context "when page_title is not assigned" do
      {
        "new" => "New Post",
        "create" => "New Post",
        "edit" => "Edit Post",
        "update" => "Edit Post"
      }.each do |action, title|
        it "should show the correct I18n text on the #{action} action" do
          params[:action] = action
          page = ActiveAdmin::Views::Pages::Form.new(arbre_context)
          expect(page.title).to eq title
        end
      end
    end
  end
end
