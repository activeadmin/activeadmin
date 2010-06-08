require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
include ActiveAdminIntegrationSpecHelper

# Actually Describes ActiveAdmin::FormBuilder, but RSpec 2 has
# issues setting this up without a whole bunch of hackery
describe Admin::PostsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

  def build_form(*args, &block)
    Admin::PostsController.filters(*args, &block)
    get :index
  end

  before do
    build_form do |f|
      f.filter :title
      f.filter :body
      f.filter :created_at
    end
  end

  it "should generate a search field for a string attribute" do
    response.should have_tag("input", :attributes => { :name => "q[title_contains]"})
  end

  it "should label a text field with search" do
    response.should have_tag('label', 'Search Title')
  end

  it "should generate a search field for a text attribute" do
    puts response.body
    response.should have_tag("input", :attributes => { :name => "q[body_contains]"})
  end

  it "should only generate the form once" do
    response.body.scan(/q\[title_contains\]/).size.should == 1
  end


  context "when date" do
    it "should generate a date greater than" do
      response.should have_tag("input", :attributes => { :name => "q[created_at_gte]" })
    end
    it "should generate a date less than" do
      response.should have_tag("input", :attributes => { :name => "q[created_at_lte]" })
    end
  end

end
