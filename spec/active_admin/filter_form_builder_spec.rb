require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 
include ActiveAdminIntegrationSpecHelper

# Actually Describes ActiveAdmin::FormBuilder, but RSpec 2 has
# issues setting this up without a whole bunch of hackery
describe Admin::PostsController do

  include RSpec::Rails::ControllerExampleGroup
  render_views  

  before do
    @john = User.create :first_name => "John", :last_name => "Doe", :username => "john_doe"
    @jane = User.create :first_name => "Jane", :last_name => "Doe", :username => "jane_doe"
    Admin::PostsController.reset_filters!
    Admin::PostsController.filter :title
    Admin::PostsController.filter :body
    Admin::PostsController.filter :created_at
    Admin::PostsController.filter :id
    Admin::PostsController.filter :author
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

  it "should generate a clear filters link" do
    response.should have_tag("a", "Clear Filters", :attributes => { :class => "clear_filters_btn" })
  end


  context "when date" do
    it "should generate a date greater than" do
      response.should have_tag("input", :attributes => { :name => "q[created_at_gte]", :class => "datepicker"})
    end
    it "should generate a date less than" do
      response.should have_tag("input", :attributes => { :name => "q[created_at_lte]", :class => "datepicker"})
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

  context "when belong to" do
    context "as select" do
      it "should generate a select" do
        response.should have_tag("select", :attributes => {
                                            :name => "q[author_id_eq]"})
      end
      it "should set the default text to 'Any'" do
        response.should have_tag("option", "Any", :attributes => {
                                                    :value => "" })
      end
      it "should create an option for each related object" do
        response.should have_tag("option", "john_doe", :attributes => {
                                                          :value => @john.id })
        response.should have_tag("option", "jane_doe", :attributes => {
                                                          :value => @jane.id })
      end
    end
  end

end
