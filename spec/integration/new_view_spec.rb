require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe_with_render "New View" do

  before :all do
    load_defaults!
    reload_routes!
  end

  before(:each) do
    Admin::PostsController.reset_form_config!
  end

  describe "GET #new" do
    
    it "should generate a default form with no config" do
      get :new
      response.should have_tag("input", :attributes => {
        :type => "text",
        :name => "post[title]"
      })
      response.should have_tag("textarea", :attributes => {
        :name => "post[body]"
      })
      
      response.should have_tag("a", :attributes => { :href => "/admin/posts" }, :ancestor => { :tag => "li" })
    end

    describe "when generating a complex form" do
      before(:each) do
        ActiveAdmin.register Post do
          form do |f|
            f.inputs "Your Post" do
              f.input :title
              f.input :body
            end
            f.inputs "Publishing" do
              f.input :published_at
            end
            f.buttons
          end
        end
        get :new
      end
      it "should create a field set" do
        response.should have_tag("legend", "Your Post") 
      end
      it "should create a title field inside the fieldset" do
        response.should have_tag("input", :attributes => { :type => "text", :name => 'post[title]' },
                                          :ancestor => { :tag => "fieldset" })
      end
    end

    describe "generating a form from a partial" do
      require 'fileutils'

      before do
        @filename = Rails.root + "app/views/admin/posts/_form.html.erb"
        FileUtils.mkdir_p(Rails.root + "app/views/admin/posts")
        File.open(@filename, 'w+') do |f|
          f << "Hello World"
        end
        ActiveAdmin.register Post do
          form :partial => "form"
        end
      end

      after do
        File.delete(@filename)
      end

      it "should render the partial" do
        get :new
        response.body.should include("Hello World")
      end
    end
  end
end
