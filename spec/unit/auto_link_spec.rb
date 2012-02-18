require 'spec_helper'

describe "auto linking resources" do
  setup_arbre_context!

  include ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
  include ActiveAdmin::ViewHelpers::AutoLinkHelper
  include ActiveAdmin::ViewHelpers::DisplayHelper

  let(:active_admin_namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin) }
  let(:post){ Post.create! :title => "Hello World" }

  context "when the resource is not registered" do
    it "should return the display name of the object" do
      auto_link(post).should == "Hello World"
    end
  end

  context "when the resource is registered" do
    before do
      active_admin_namespace.register Post
    end
    it "should return a link with the display name of the object" do
      self.should_receive(:link_to).with("Hello World", admin_post_path(post.id))
      auto_link(post)
    end
  end

  context "when the resource has to_param defined and is registered" do
    before do
      active_admin_namespace.register Post
      post.stub!(:to_param){ post.title.parameterize }
    end
    it "should return a link with the display name of the object" do
      self.should_receive(:link_to).with("Hello World", admin_post_path(post.id))
      auto_link(post)
    end
  end

end
