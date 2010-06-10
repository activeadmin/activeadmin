require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
include ActiveAdminIntegrationSpecHelper

# Actually Describes ActiveAdmin::FormBuilder, but RSpec 2 has
# issues setting this up without a whole bunch of hackery
describe Admin::PostsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

  before do
    Admin::PostsController.reset_filters!
    Admin::PostsController.filter :title
    Admin::PostsController.filter :body
    Admin::PostsController.filter :created_at
    Admin::PostsController.filter :id
    get :index
  end

  it "should generate a form which submits via get" do
    response.should have_tag("form", :attributes => { :method => 'get' })
  end

  it "should generate a filter button" do
    response.should have_tag("input", :attributes => { :type => "submit",
                                                        :value => "Filter" })
  end

  it "should generate a search field for a string attribute" do
    response.should have_tag("input", :attributes => { :name => "q[title_contains]"})
  end

  it "should label a text field with search" do
    response.should have_tag('label', 'Search Title')
  end

  it "should generate a search field for a text attribute" do
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

  context "when integer" do
    it "should generate a select option for equal to" do
      response.should have_tag("option", "Equal To", :attributes => { :value => 'id_eq' })
    end
    it "should generate a select option for greater than" do
      response.should have_tag("option", "Greater Than")
    end
    it "should generate a select option for less than" do
      response.should have_tag("option", "Less Than")
    end
    it "should generate a text field for input" do
      response.should have_tag("input", :attributes => {
                                          :name => "q[id_eq]" })
    end
    it "should select the option which is currently being filtered"
  end

end
