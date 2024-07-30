# frozen_string_literal: true
require "rails_helper"

module ActiveAdmin
  RSpec.describe Resource, "Attributes" do
    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { ActiveAdmin::Namespace.new application, :admin }
    let(:resource_config) { ActiveAdmin::Resource.new namespace, Post }

    describe "#resource_attributes" do
      subject do
        resource_config.resource_attributes
      end

      it "should return attributes hash" do
        expect(subject).to eq(
          author_id: :author,
          body: :body,
          created_at: :created_at,
          custom_category_id: :category,
          foo_id: :foo_id,
          position: :position,
          published_date: :published_date,
          starred: :starred,
          title: :title,
          updated_at: :updated_at)
      end

      it "does not return sensitive attributes" do
        keep = ActiveAdmin.application.filter_attributes
        ActiveAdmin.application.filter_attributes = [:published_date]
        expect(subject).to_not include :published_date
        ActiveAdmin.application.filter_attributes = keep
      end

      context "when resource has a counter cache" do
        subject { ActiveAdmin::Resource.new(namespace, Category).resource_attributes }

        it "should not include counter cache column" do
          expect(subject.keys).not_to include(:posts_count)
        end
      end

      context "when resource has a 'counter cache'-like column" do
        subject { ActiveAdmin::Resource.new(namespace, User).resource_attributes }

        it "should include that attribute" do
          expect(subject).to include(sign_in_count: :sign_in_count)
        end
      end
    end

    describe "#association_columns" do
      subject do
        resource_config.association_columns
      end

      it "should return associations" do
        expect(subject).to eq([:author, :category])
      end
    end

    describe "#content_columns" do
      subject do
        resource_config.content_columns
      end

      it "should return columns without associations" do
        expect(subject).to eq([:title, :body, :published_date, :position, :starred, :foo_id, :created_at, :updated_at])
      end
    end
  end
end
