# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::AutoLinkHelper, type: :helper do
  let(:linked_post) { helper.auto_link(post) }

  let(:active_admin_namespace) { ActiveAdmin.application.namespace(:admin) }
  let(:post) { Post.create! title: "Hello World" }

  before do
    helper.class.send(:include, ActiveAdmin::DisplayHelper)
    helper.class.send(:include, ActiveAdmin::LayoutHelper)
    helper.class.send(:include, MethodOrProcHelper)
    allow(helper).to receive(:authorized?).and_return(true)
    allow(helper).to receive(:active_admin_namespace).and_return(active_admin_namespace)
    allow(helper).to receive(:url_options).and_return({})
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
      expect(helper).to receive(:url_options).and_return(locale: "en")

      expect(linked_post).to \
        match(%r{<a href="/admin/posts/\d+\?locale=en">Hello World</a>})
    end

    context "but the user doesn't have access" do
      before do
        allow(helper).to receive(:authorized?).and_return(false)
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
      expect(helper).to receive(:url_options).and_return(locale: "en")

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
