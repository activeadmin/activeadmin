require 'rails_helper'
require 'active_admin/view_helpers/active_admin_application_helper'
require 'active_admin/view_helpers/auto_link_helper'
require 'active_admin/view_helpers/display_helper'
require 'active_admin/view_helpers/method_or_proc_helper'

RSpec.describe "#auto_link" do
  let(:view_klass) do
    Class.new(ActionView::Base) do
      include ActiveAdmin::ViewHelpers::ActiveAdminApplicationHelper
      include ActiveAdmin::ViewHelpers::AutoLinkHelper
      include ActiveAdmin::ViewHelpers::DisplayHelper
      include MethodOrProcHelper
    end
  end

  let(:view) { mock_action_view(view_klass) }

  let(:linked_post) { view.auto_link(post) }

  let(:active_admin_namespace) { ActiveAdmin.application.namespace(:admin) }
  let(:post) { Post.create! title: "Hello World" }

  before do
    allow(view).to receive(:authorized?).and_return(true)
    allow(view).to receive(:active_admin_namespace).and_return(active_admin_namespace)
    allow(view).to receive(:url_options).and_return({})
  end

  context "when the resource is not registered" do
    before do
      load_resources {}
    end

    it "should return the display name of the object" do
      expect(linked_post).to eq "Hello World"
    end
  end

  context "when the resource is registered" do
    before do
      load_resources do
        active_admin_namespace.register Post
      end
    end

    it "should return a link with the display name of the object" do
      expect(linked_post).to \
          match(%r{<a href="/admin/posts/\d+">Hello World</a>})
    end

    it "should keep locale in the url if present" do
      expect(view).to receive(:url_options).and_return(locale: 'en')

      expect(linked_post).to \
          match(%r{<a href="/admin/posts/\d+\?locale=en">Hello World</a>})
    end

    context "but the user doesn't have access" do
      before do
        allow(view).to receive(:authorized?).and_return(false)
      end

      it "should return the display name of the object" do
        expect(linked_post).to eq "Hello World"
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
      expect(linked_post).to \
        match(%r{<a href="/admin/posts/\d+/edit">Hello World</a>})
    end

    it "should keep locale in the url if present" do
      expect(view).to receive(:url_options).and_return(locale: 'en')

      expect(linked_post).to \
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
    end

    it "should return the display name of the object" do
      expect(linked_post).to eq "Hello World"
    end
  end
end
