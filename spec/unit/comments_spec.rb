require 'spec_helper'

describe "Comments" do
  let(:application) { ActiveAdmin::Application.new }

  describe ActiveAdmin::Comment do
    subject(:comment){ ActiveAdmin::Comment.new }

    it "has valid Associations and Validations" do
      expect(comment).to belong_to :resource
      expect(comment).to belong_to :author
      expect(comment).to validate_presence_of :resource
      expect(comment).to validate_presence_of :body
      expect(comment).to validate_presence_of :namespace
    end

    describe ".find_for_resource_in_namespace" do
      let(:post) { Post.create!(title: "Hello World") }
      let(:namespace_name) { "admin" }

      before do
        @comment = ActiveAdmin::Comment.create! resource: post,
                                                body: "A Comment",
                                                namespace: namespace_name
      end

      it "should return a comment for the resource in the same namespace" do
        expect(ActiveAdmin::Comment.find_for_resource_in_namespace(post, namespace_name)).to eq [@comment]
      end

      it "should not return a comment for the same resource in a different namespace" do
        expect(ActiveAdmin::Comment.find_for_resource_in_namespace(post, 'public')).to eq []
      end

      it "should not return a comment for a different resource" do
        another_post = Post.create! title: "Another Hello World"
        expect(ActiveAdmin::Comment.find_for_resource_in_namespace(another_post, namespace_name)).to eq []
      end
    end

    describe ".resource_id_cast" do
      let(:post) { Post.create!(title: "Testing.") }
      let(:namespace_name) { "admin" }

      it "should cast resource_id as string" do
        comment = ActiveAdmin::Comment.create! resource: post,
                                                body: "Another Comment",
                                                namespace: namespace_name
        expect(ActiveAdmin::Comment.resource_id_cast(comment).class).to eql String
      end
    end

    describe ".resource_type" do
      let(:post) { Post.create!(title: "Testing.") }
      let(:post_decorator) { double 'PostDecorator' }

      before { post_decorator.stub model: post, :decorated? => true }

      context "when a decorated object is passed" do
        let(:resource) { post_decorator }

        it "returns undeorated object class string" do
          expect(ActiveAdmin::Comment.resource_type resource).to eql 'Post'
        end
      end

      context "when an undecorated object is passed" do
        let(:resource) { post }

        it "returns object class string" do
          expect(ActiveAdmin::Comment.resource_type resource).to eql 'Post'
        end
      end
    end

    describe ".resource_id_type" do
      it "should be :string" do
        expect(ActiveAdmin::Comment.resource_id_type).to eql :string
      end
    end

    describe "Commenting on resource with string id" do
      let(:tag) { Tag.create!(name: "cooltags") }
      let(:namespace_name) { "admin" }

      it "should allow commenting" do
        comment = ActiveAdmin::Comment.create!(
          resource: tag,
          body: "Another Comment",
          namespace: namespace_name)

        expect(ActiveAdmin::Comment.find_for_resource_in_namespace(tag, namespace_name)).to eq [comment]
      end
    end

    describe "commenting on child of STI resource" do
      let(:publisher) { Publisher.create!(username: "tenderlove") }
      let(:namespace_name) { "admin" }

      it "should assign child class as commented resource" do
        comment = ActiveAdmin::Comment.create!(
          resource: publisher,
          body: "Lorem Ipsum",
          namespace: namespace_name)

        expect(ActiveAdmin::Comment.find_for_resource_in_namespace(publisher, namespace_name).last.resource_type).
          to eq('Publisher')
      end
    end
  end

  describe ActiveAdmin::Comments::NamespaceHelper do
    describe "#comments?" do

      it "should have comments when the namespace allows comments" do
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.allow_comments = true
        expect(ns.comments?).to be_true
      end

      it "should not have comments when the namespace does not allow comments" do
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.allow_comments = false
        expect(ns.comments?).to be_false
      end
    end
  end

  describe ActiveAdmin::Comments::ResourceHelper do
    it "should add an attr_accessor :comments to ActiveAdmin::Resource" do
      ns = ActiveAdmin::Namespace.new(application, :admin)
      resource = ActiveAdmin::Resource.new(ns, Post)
      expect(resource.comments).to be_nil
      resource.comments = true
      expect(resource.comments).to be_true
    end
    it "should disable comments if set to false" do
      ns = ActiveAdmin::Namespace.new(application, :admin)
      resource = ActiveAdmin::Resource.new(ns, Post)
      resource.comments = false
      expect(resource.comments?).to be_false
    end
  end
end
