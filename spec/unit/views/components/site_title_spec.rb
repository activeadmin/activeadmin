# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::SiteTitle do
  subject do
    render_arbre_component({ namespace: namespace }, helpers) do
      insert_tag ActiveAdmin::Views::SiteTitle, assigns[:namespace]
    end
  end

  let(:helpers) { mock_action_view }
  let(:namespace) do
    settings = ActiveAdmin::SettingsNode.build(ActiveAdmin::NamespaceSettings)
    settings.use_webpacker = use_webpacker
    settings.site_title = site_title
    settings.site_title_image = site_title_image
    settings.site_title_link = site_title_link
    settings
  end
  let(:use_webpacker) { ActiveAdmin.application.use_webpacker }
  let(:site_title) { nil }
  let(:site_title_image) { nil }
  let(:site_title_link) { nil }

  context "when a value" do
    context "is a string" do
      let(:site_title) { "Hello World" }

      it "renders the string" do
        expect(subject.content).to eq "Hello World"
      end
    end

    context "is a symbol" do
      let(:site_title) { :hello_world }

      it "renders the return value of a method" do
        expect(helpers).to receive(:hello_world).and_return("Hello World")
        expect(subject.content).to eq "Hello World"
      end
    end

    context "is a proc" do
      let(:site_title) { proc { "Hello World" } }

      it "renders the return value of the proc" do
        expect(subject.content).to eq "Hello World"
      end
    end
  end

  context "when an image" do
    context "when a string is passed in" do
      let(:site_title_image) { "logo.png" }

      it "renders the string when a string is passed in" do
        if use_webpacker
          expect(helpers).to receive(:image_pack_tag).once.and_call_original
          expect(subject.content).to match %r{<img id="site_title_image" src="/packs-test/media/images/logo-[a-z0-9]+.png" />}
        else
          expect(helpers).to receive(:image_tag).once.and_call_original
          expect(subject.content).to match %r{<img id="site_title_image" src="/assets/logo-[a-z0-9]+.png" />}
        end
      end
    end
  end

  context "when a link is present" do
    let(:site_title) { "Hello Wrold" }
    let(:site_title_link) { "/" }

    it "renders the string when a string is passed in" do
      expect(subject.content).to eq "<a href=\"#{site_title_link}\">#{site_title}</a>"
    end
  end
end
