# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Scopes do
  describe "the scopes list" do
    let(:collection) { Post.all }
    let(:active_admin_config) { ActiveAdmin.register(Post) }

    let(:assigns) do
      {
        active_admin_config: active_admin_config,
        collection_before_scope: collection
      }
    end

    let(:helpers) do
      helpers = mock_action_view

      allow(helpers.request)
        .to receive(:path_parameters)
        .and_return(controller: "admin/posts", action: "index")

      helpers
    end

    let(:configured_scopes) do
      [
        ActiveAdmin::Scope.new(:all),
        ActiveAdmin::Scope.new(:published) { |posts| posts.where.not(published_date: nil) }
      ]
    end

    let(:scope_options) do
      { scope_count: true }
    end

    let(:scopes) do
      scopes_to_render = configured_scopes
      options = scope_options

      render_arbre_component assigns, helpers do
        insert_tag(ActiveAdmin::Views::Scopes, scopes_to_render, options)
      end
    end

    before do
      allow(ActiveAdmin::AsyncCount).to receive(:new).and_call_original
    end

    around do |example|
      with_resources_during(example) { active_admin_config }
    end

    it "renders the scopes component" do
      html = Capybara.string(scopes.to_s)
      expect(html).to have_css("div.scopes")

      configured_scopes.each do |scope|
        expect(html).to have_css("a[href='/admin/posts?scope=#{scope.id}']")
      end
    end

    it "uses AsyncCounts when available", if: Post.respond_to?(:async_count) do
      scopes

      expect(ActiveAdmin::AsyncCount).to have_received(:new).with(Post.all)
      expect(ActiveAdmin::AsyncCount).to have_received(:new).with(Post.where.not(published_date: nil))
    end

    it "avoids AsyncCounts when unavailable", unless: Post.respond_to?(:async_count) do
      scopes

      expect(ActiveAdmin::AsyncCount).not_to have_received(:new)
    end

    context "when an individual scope is configured to hide its count" do
      let(:configured_scopes) do
        [
          ActiveAdmin::Scope.new(:all, nil, show_count: false)
        ]
      end

      it "avoids AsyncCounts" do
        scopes

        expect(ActiveAdmin::AsyncCount).not_to have_received(:new)
      end
    end

    context "when a scope is not to be displayed" do
      let(:configured_scopes) do
        [
          ActiveAdmin::Scope.new(:all, nil, if: -> { false })
        ]
      end

      it "avoids AsyncCounts" do
        scopes

        expect(ActiveAdmin::AsyncCount).not_to have_received(:new)
      end
    end

    context "when :show_count is configured as false" do
      let(:scope_options) do
        { scope_count: false }
      end

      it "avoids AsyncCounts" do
        scopes

        expect(ActiveAdmin::AsyncCount).not_to have_received(:new)
      end
    end
  end
end
