require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdminIntegrationSpecHelper

describe ActiveAdmin::FormBuilder do

  include ControllerExampleGroupBehaviour
  before do
    @controller = Admin::PostsController.new
  end

  def build_form(&block)
    Admin::PostsController.form(&block)
    get :new
  end

  context "in general" do
    before do
      build_form do |f|
        f.inputs do
          f.input :title
          f.input :body
        end
        f.buttons do
          f.commit_button "Submit Me"
          f.commit_button "Another Button"
        end
      end
    end
    it "should generate a text input" do
      response.should have_tag("input", :attributes => { :type => "text",
                                                     :name => "post[title]" })
    end
    it "should generate a textarea" do
      response.should have_tag("textarea", :attributes => { :name => "post[body]" })
    end
    it "should generate buttons" do
      response.should have_tag("input", :attributes => {  :type => "submit",
                                                          :value => "Submit Me" })
      response.should have_tag("input", :attributes => {  :type => "submit",
                                                          :value => "Another Button" })
    end
  end

  context "without passing a block to inputs" do
    before do
      build_form do |f|
        f.inputs :title, :body
      end
    end
    it "should have a title input" do
      response.should have_tag("input", :attributes => { :type => "text",
                                                          :name => "post[title]" })
    end
    it "should have a body textarea" do
      response.should have_tag("textarea", :attributes => { :name => "post[body]" })
    end
  end

  context "with fields for" do
    before do
      build_form do |f|
        f.inputs do
          f.input :title
          f.input :body
        end
        f.instance_eval do
          @object.author = User.new
        end
        f.semantic_fields_for :author do |author|
          author.inputs :first_name, :last_name
        end
      end
    end
    it "should generate a nested text input once" do
      response.body.scan("post_author_attributes_first_name_input").size.should == 1
    end
  end
end
