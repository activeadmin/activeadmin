require 'rails_helper'

RSpec.describe ActiveAdmin::Views::Pages::Form do
  let!(:application) { ActiveAdmin::Application.new }
  let(:namespace) { ActiveAdmin::Namespace.new(application, "Admin") }
  let!(:params) { { controller: "PostsController", action: "edit" } }
  let(:helpers) do
    helpers = mock_action_view
    allow(helpers).to receive(:active_admin_config).and_return(namespace.register(Post))
    allow(helpers).to receive(:params).and_return(params)
    helpers
  end

  let(:arbre_context) do
    OpenStruct.new(params: params, helpers: helpers, assigns: {})
  end

  let(:page) do
    ActiveAdmin::Views::Pages::Form.new(arbre_context)
  end

  describe "#options" do
    it "should include valid uri for new record" do
      allow(page).to receive(:resource).and_return(Post.new)
      expect(page.options[:url]).to eq('/admin/posts')
    end
    it "should include valid uri for persisted record" do
      post = Post.create
      allow(page).to receive(:resource).and_return(post)
      expect(page.options[:url]).to eq("/admin/posts/#{post.id}")
    end
  end

  describe "#title" do

    context "when :title is set" do
      it "should show the set page title" do
        expect(page).to receive(:resource)
        expect(page).to receive(:form_presenter).twice.and_return(title: "My Page Title")
        expect(page.title).to eq "My Page Title"
      end
    end

    context "when page_title is assigned" do
      it "should show the set page title" do
        arbre_context.assigns[:page_title] = "My Page Title"
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
          expect(page.title).to eq title
        end
      end
    end
  end
end
