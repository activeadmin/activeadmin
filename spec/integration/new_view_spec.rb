require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdminIntegrationSpecHelper

describe Admin::PostsController, :type => :controller do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

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
    end

    it "should generate a form with simple symbol configuration"

    describe "when generating a complex form" do
      before(:each) do
        Admin::PostsController.form do |f|
          f.inputs "Your Post" do
            f.input :title
            f.input :body
          end
          f.inputs "Publishing" do
            f.input :published_at
          end
          f.buttons
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
  end
end
