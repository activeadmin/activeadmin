require 'spec_helper'

describe "Comments" do
  let(:application){ ActiveAdmin::Application.new }

  describe "Configuration" do
    it "should have an array of namespaces which allow comments" do
      application.allow_comments_in.should be_an_instance_of(Array)
    end

    it "should allow comments in the default namespace by default" do
      application.allow_comments_in.should include(application.default_namespace)
    end
  end

  describe ActiveAdmin::Comment do
    describe "Associations and Validations" do
      it { should belong_to :resource }
      it { should belong_to :author }

      it { should validate_presence_of :resource_id }
      it { should validate_presence_of :resource_type }
      it { should validate_presence_of :body }
      it { should validate_presence_of :namespace }
    end
  end

  describe ActiveAdmin::Comments::NamespaceHelper do
    describe "#comments?" do
      it "should have comments if the namespace is in the settings" do
        ns = ActiveAdmin::Namespace.new(application, :admin)
        ns.comments?.should be_true
      end
      it "should not have comments if the namespace is not in the settings" do
        ns = ActiveAdmin::Namespace.new(application, :not_in_comments)
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
