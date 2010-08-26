require File.expand_path(File.dirname(__FILE__) + '/../spec_helper') 


describe_with_render ActiveAdmin::FormBuilder do

  def reset!
    Admin::PostsController.reset_filters!
  end

  def filter(*args)
    Admin::PostsController.filter *args
  end

  before do
    @john = User.create :first_name => "John", :last_name => "Doe", :username => "john_doe"
    @jane = User.create :first_name => "Jane", :last_name => "Doe", :username => "jane_doe"
    reset!
    filter :title
    filter :body
    filter :created_at
    filter :id
    filter :author
    get :index
  end

  after(:each) do
    reset!
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

    context "when given as the _id attribute name" do
      before do
        filter :author_id
        get :index
      end
      it "should not render as an integer" do
        response.should_not have_tag("input", :attributes => {
                                                :name => "q[author_id_eq]"})
      end
      it "should render as belongs to select" do
        response.should have_tag("select", :attributes => {
                                            :name => "q[author_id_eq]"})
        response.should have_tag("option", "jane_doe", :attributes => {
                                                          :value => @jane.id })
      end
    end

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
      context "with a proc" do
        before do
          reset!
          filter :title, :as => :select, :collection => proc{ ['Title One', 'Title Two'] }
          get :index
        end
        it "should use call the proc as the collection" do
          response.should have_tag("option", "Title One")
          response.should have_tag("option", "Title Two")
        end
      end
    end

    context "as check boxes" do
      before do
        filter :author, :as => :check_boxes
        get :index
      end
      it "should create a check box for each related object" do
        response.should have_tag("input", :attributes => {
                                            :name => "q[author_id_in][]",
                                            :type => "checkbox",
                                            :value => @john.id })
        response.should have_tag("input", :attributes => {
                                            :name => "q[author_id_in][]",
                                            :type => "checkbox",          
                                            :value => @jane.id })
      end
    end
  end # belongs to

  describe "default filters" do
    it "should order by association, then content columns" do
      attributes = controller.class.default_filters_config.collect{|f| f[:attribute] }
      attributes.should == [ :author, :title, :body, :published_at, :created_at, :updated_at ]
    end
  end

end
