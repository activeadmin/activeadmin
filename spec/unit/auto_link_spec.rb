require 'spec_helper'

class AutoLinkMockResource
  attr_accessor :namespace
  def initialize(namespace)
    @namespace = namespace
  end
end

describe "auto linking resources" do
  include ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
  include ActiveAdmin::ViewHelpers::AutoLinkHelper
  include ActiveAdmin::ViewHelpers::DisplayHelper

  let(:active_admin_config) { AutoLinkMockResource.new(namespace) }
  let(:active_admin_namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin) }
  let(:post){ Post.create! :title => "Hello World" }

  def admin_post_path(post)
    "/admin/posts/#{post.id}"
  end

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
      self.should_receive(:link_to).with("Hello World", admin_post_path(post))
      auto_link(post)
    end
  end

end
