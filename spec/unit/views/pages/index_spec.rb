require 'rails_helper'

describe ActiveAdmin::Views::Pages::Index do
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

    context "when config[:title] is assigned" do
      context "with a Proc" do
        it "should return the value of the assigned Proc" do
          page = ActiveAdmin::Views::Pages::Index.new(arbre_context)
          allow(page).to receive(:config).and_return(title: ->{ "My Page Title" })
          expect(page.title).to eq "My Page Title"
        end
      end

      context "with a String" do
        it "should return the assigned String" do
          page = ActiveAdmin::Views::Pages::Index.new(arbre_context)
          allow(page).to receive(:config).and_return(title: ->{ "My Page Title" })
          expect(page.title).to eq "My Page Title"
        end
      end

      context "with a Integer" do
        it "should return the Integer" do
          page = ActiveAdmin::Views::Pages::Index.new(arbre_context)
          allow(page).to receive(:config).and_return(title: 1)
          expect(page.title).to eq 1
        end
      end
    end

    context "when page_title is assigned" do
      it "should return the set page title" do
        arbre_context.assigns[:page_title] = "My Page Title"
        page = ActiveAdmin::Views::Pages::Index.new(arbre_context)
        expect(page.title).to eq "My Page Title"
      end
    end

    context "when page_title is not assigned" do
      it "should return the correct I18n text" do
        page = ActiveAdmin::Views::Pages::Index.new(arbre_context)
        expect(page.title).to eq "Posts"
      end
    end
  end
end
