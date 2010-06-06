require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
include ActiveAdminIntegrationSpecHelper

# Actually Describes ActiveAdmin::FormBuilder, but RSpec 2 has
# issues setting this up without a whole bunch of hackery
describe Admin::PostsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

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
        f.label :title, "My Super Title"
        f.text_field :title
        f.buttons do
          f.submit "My Submit Button"
          f.commit_button "Submit Me"
          f.commit_button "Another Button"
        end
      end
    end
    it "should generate a text input" do
      response.should have_tag("input", :attributes => { :type => "text",
                                                     :name => "post[title]" })
    end
    it "should generate a label using the default form methods" do
      response.should have_tag("label", "My Super Title")
    end
    it "should generate a textarea" do
      response.should have_tag("textarea", :attributes => { :name => "post[body]" })
    end
    it "should only generate the form once" do
      response.body.scan(/My Super Title/).size.should == 1
    end
    it "should generate buttons" do
      response.should have_tag("input", :attributes => {  :type => "submit",
                                                          :value => "Submit Me" })
      response.should have_tag("input", :attributes => {  :type => "submit",
                                                          :value => "Another Button" })
    end
  end

  context "with buttons" do
    it "should generate the form once" do
      build_form do |f|
        f.inputs do
          f.input :title
        end
        f.buttons
      end
      response.body.scan(/id=\"post_title\"/).size.should == 1
    end
    it "should generate one button" do
      build_form do |f|
        f.buttons
      end
      response.body.scan(/type=\"submit\"/).size.should == 1
    end
    it "should generate multiple buttons" do
      build_form do |f|
        f.buttons do
          f.submit "Create"
          f.commit_button "Create & Continue"
          f.commit_button "Create & Edit"
        end
      end
      response.body.scan(/type=\"submit\"/).size.should == 3
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

  context "with semantic fields for" do
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

  context "with collection inputs" do
    before do
      User.create :first_name => "John", :last_name => "Doe"
      User.create :first_name => "Jane", :last_name => "Doe"
    end

    describe "as select" do
      before do
        build_form do |f|
          f.input :author
        end
      end
      it "should create 2 options" do
        response.body.scan(/\<option/).size.should == 3
      end
    end

    describe "as radio buttons" do
      before do
        build_form do |f|
          f.input :author, :as => :radio
        end
      end
      it "should create 2 radio buttons" do
        response.body.scan(/type=\"radio\"/).size.should == 2
      end
    end
  end

  context "with inputs 'for'" do
    before do
      build_form do |f|
        f.inputs do
          f.input :title
          f.input :body
        end
        f.instance_eval do
          @object.author = User.new
        end
        f.inputs :name => 'Author', :for => :author do |author|
          author.inputs :first_name, :last_name
        end
      end
    end
    it "should generate a nested text input once" do
      response.body.scan("post_author_attributes_first_name_input").size.should == 1
    end
    it "should add an author first name field" do
      response.body.should have_tag("input", :attributes => { :name => "post[author_attributes][first_name]"})
    end
  end

  context "with wrapper html" do
    it "should set a class" do
      build_form do |f|
        f.input :title, :wrapper_html => { :class => "important" }
      end
      response.should have_tag("li", :attributes => {:class => "string optional important"})
    end
  end


  # This checks that each input can be added via the standard
  # rails method as well as using the form builder's #input method.
  { 
    "input :title, :as => :string"        => /id\=\"post_title\"/,
    "text_field :title"                   => /id\=\"post_title\"/,
    "input :title, :as => :text"          => /id\=\"post_title\"/,
    "text_area :title"                    => /id\=\"post_title\"/,
    "input :created_at, :as => :time"     => /id\=\"post_created_at_2i\"/,
    "time_select :created_at"             => /id\=\"post_created_at_2i\"/,
    "input :created_at, :as => :datetime" => /id\=\"post_created_at_2i\"/,
    "datetime_select :created_at"         => /id\=\"post_created_at_2i\"/,
    "input :created_at, :as => :date"     => /id\=\"post_created_at_2i\"/,
    "date_select :created_at"             => /id\=\"post_created_at_2i\"/,
    "radio_button :title, 'title'"        => /id\=\"post_title_title\"/,
    "file_field :title"                   => /id\=\"post_title\"/,
    "hidden_field :title"                 => /id\=\"post_title\"/,
    "label :title"                        => /for\=\"post_title\"/,
  }.each do |source, regex|
   it "should properly buffer #{source}" do
     build_form do |f|
       f.instance_eval(source)
       f.instance_eval(source)
     end
     response.body.scan(regex).size.should == 2
   end
  end
      

end
