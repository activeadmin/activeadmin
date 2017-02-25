require 'rails_helper'
require 'active_admin/view_helpers/active_admin_application_helper'
require 'active_admin/view_helpers/auto_link_helper'
require 'active_admin/view_helpers/display_helper'
require 'active_admin/view_helpers/method_or_proc_helper'

RSpec.describe "auto linking resources", type: :view do
  include ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
  include ActiveAdmin::ViewHelpers::AutoLinkHelper
  include ActiveAdmin::ViewHelpers::DisplayHelper
  include MethodOrProcHelper

  let(:active_admin_namespace){ ActiveAdmin.application.namespace(:admin) }
  let(:post){ Post.create! title: "Hello World" }

  before do
    allow(self).to receive(:authorized?).and_return(true)
  end

  context "when the resource is not registered" do
    before do
      load_resources {}
    end

    it "should return the display name of the object" do
      expect(auto_link(post)).to eq "Hello World"
    end
  end

  context "when the resource is registered" do
    before do
      load_resources do
        active_admin_namespace.register Post
      end
    end

    it "should return a link with the display name of the object" do
      expect(auto_link(post)).to \
          match(%r{<a href="/admin/posts/\d+">Hello World</a>})
    end

    it "should keep locale in the url if present" do
      expect(self).to receive(:url_options).and_return(locale: 'en')

      expect(auto_link(post)).to \
          match(%r{<a href="/admin/posts/\d+\?locale=en">Hello World</a>})
    end

    context "but the user doesn't have access" do
      before do
        allow(self).to receive(:authorized?).and_return(false)
      end

      it "should return the display name of the object" do
        expect(auto_link(post)).to eq "Hello World"
      end
    end
  end

  context "when the resource is registered with the show action disabled" do
    before do
      load_resources do
        active_admin_namespace.register(Post) { actions :all, except: :show }
      end
    end

    it "should fallback to edit" do
      expect(auto_link(post)).to \
        match(%r{<a href="/admin/posts/\d+/edit">Hello World</a>})
    end

    it "should keep locale in the url if present" do
      expect(self).to receive(:url_options).and_return(locale: 'en')

      expect(auto_link(post)).to \
        match(%r{<a href="/admin/posts/\d+/edit\?locale=en">Hello World</a>})
    end
  end

  context "when the resource is registered with the show & edit actions disabled" do
    before do
      load_resources do
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
