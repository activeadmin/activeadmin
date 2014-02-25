require "spec_helper"

describe ActiveAdmin::Views::Pages::Form do
  describe "#title" do
    let!(:application){ ActiveAdmin::Application.new }
    let(:namespace){ ActiveAdmin::Namespace.new(application, "Admin") }
    let!(:params){ { controller: "UsersController", action: "edit" } }
    let(:helpers) do
      helpers = mock_action_view
      helpers.stub active_admin_config: namespace.register(Post),
                   params: params

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
      it "should show the correct I18n text" do
        page = ActiveAdmin::Views::Pages::Form.new(arbre_context)
        expect(page.title).to eq "Edit Post"
      end
    end
  end
end
