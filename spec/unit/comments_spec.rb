require 'spec_helper'

describe "Comments" do
  let(:application){ ActiveAdmin::Application.new }

  describe ActiveAdmin::Comment do
    describe "Associations and Validations" do
      it { should belong_to :resource }
      it { should belong_to :author }

      it { should validate_presence_of :resource }
      it { should validate_presence_of :body }
      it { should validate_presence_of :namespace }
    end

    describe ".find_for_resource_in_namespace" do
      let(:post){ Post.create!(:title => "Hello World") }
      let(:namespace_name){ "admin" }

      before do
        @comment = ActiveAdmin::Comment.create! :resource => post,
                                                :body => "A Comment",
                                                :namespace => namespace_name
      end

      it "should return a comment for the resource in the same namespace" do
        ActiveAdmin::Comment.find_for_resource_in_namespace(post, namespace_name).should == [@comment]
      end

      it "should not return a comment for the same resource in a different namespace" do
        ActiveAdmin::Comment.find_for_resource_in_namespace(post, 'public').should == []
      end

      it "should not return a comment for a different resource" do
        another_post = Post.create! :title => "Another Hello World"
        ActiveAdmin::Comment.find_for_resource_in_namespace(another_post, namespace_name).should == []
      end
    end
  end

  describe ActiveAdmin::Comments::NamespaceHelper do
    describe "#comments?" do

      it "should have comments when the namespace allows comments" do
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.allow_comments = true
        ns.comments?.should be_true
      end

      it "should not have comments when the namespace does not allow comments" do
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.allow_comments = false
        ns.comments?.should be_false
      end

      it "should have comments when the application allows comments and no local namespace config" do
        application.allow_comments = true
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.comments?.should be_true
      end

      it "should not have comments when the application does not allow commands and no local namespace config" do
        application.allow_comments = false
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.comments?.should be_false
      end

    end
  end

  describe ActiveAdmin::Comments::ResourceHelper do
    it "should add an attr_accessor :comments to ActiveAdmin::Resource" do
      ns = ActiveAdmin::Namespace.new(application, :admin)
      resource = ActiveAdmin::Resource.new(ns, Post)
      resource.comments.should be_nil
      resource.comments = true
      resource.comments.should be_true
    end

    it "should not have comment if set to false by in allow_comments_in" do
      ns = ActiveAdmin::Namespace.new(application, application.default_namespace)
      resource = ActiveAdmin::Resource.new(ns, Post)
      resource.comments = false
      resource.comments?.should be_false
    end
  end
end
