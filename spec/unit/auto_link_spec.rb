require 'rails_helper'

describe "auto linking resources" do
  include ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
  include ActiveAdmin::ViewHelpers::AutoLinkHelper
  include ActiveAdmin::ViewHelpers::DisplayHelper
  include MethodOrProcHelper

  let(:active_admin_config)   { double namespace: namespace }
  let(:active_admin_namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin) }
  let(:post){ Post.create! title: "Hello World" }

  def admin_post_path(post)
    "/admin/posts/#{post.id}"
  end

  def authorized?(_action, _subject)
    true
  end

  context "when the resource is not registered" do
    it "should return the display name of the object" do
      expect(auto_link(post)).to eq "Hello World"
    end
  end

  context "when the resource is registered" do
    before do
      active_admin_namespace.register Post
    end
    it "should return a link with the display name of the object" do
      expect(self).to receive(:url_for) { |url| url }
      expect(self).to receive(:link_to).with "Hello World", admin_post_path(post)
      auto_link(post)
    end

    context "but the user doesn't have access" do
      it "should return the display name of the object" do
        expect(self).to receive(:authorized?).twice.and_return(false)
        expect(auto_link(post)).to eq "Hello World"
      end
    end

    context "but the show action is disabled" do
      before do
        active_admin_namespace.register(Post) { actions :all, except: :show }
      end

      it "should fallback to edit" do
        url_path = "/admin/posts/#{post.id}/edit"
        expect(self).to receive(:url_for) { |url| url }
        expect(self).to receive(:link_to).with "Hello World", url_path
        auto_link(post)
      end
    end

    context "but the show and edit actions are disabled" do
      before do
        active_admin_namespace.register(Post) do
          actions :all, except: [:show, :edit]
        end
      end

      it "should return the display name of the object" do
        expect(auto_link(post)).to eq "Hello World"
      end
    end
  end
end
