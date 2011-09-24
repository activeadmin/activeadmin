require 'spec_helper' 


describe ActiveAdmin::ViewHelpers::FilterFormHelper do

  setup_arbre_context!

  # Setup an ActionView::Base object which can be used for
  # generating the form for.
  let(:helpers) do 
    view = action_view
    def view.collection_path
      "/posts"
    end

    def view.protect_against_forgery?
      false
    end

    view
  end

  def filter(name, options = {})
    search = Post.search
    active_admin_filters_form_for(search, [options.merge(:attribute => name)])
  end

  describe "the form in general" do
    let(:body) { filter :title }

    it "should generate a form which submits via get" do
      body.should have_tag("form", :attributes => { :method => 'get', :class => 'filter_form' })
    end

    it "should generate a filter button" do
      body.should have_tag("input", :attributes => { :type => "submit",
                                                        :value => "Filter" })
    end

    it "should only generate the form once" do
      body.scan(/q\[title_contains\]/).size.should == 1
    end

    it "should generate a clear filters link" do
      body.should have_tag("a", "Clear Filters", :attributes => { :class => "clear_filters_btn" })
    end
  end

  describe "string attribute" do
    let(:body) { filter :title }

    it "should generate a search field for a string attribute" do
      body.should have_tag("input", :attributes => { :name => "q[title_contains]"})
    end

    it "should label a text field with search" do
      body.should have_tag('label', 'Search Title')
    end

    it "should translate the label for text field" do
      begin
        I18n.backend.store_translations(:en, :activerecord => { :attributes => { :post => { :title => "Name" } } })
        body.should have_tag('label', 'Search Name')
      ensure
        I18n.backend.reload!
      end
    end
  end

  describe "text attribute" do
    let(:body) { filter :body }

    it "should generate a search field for a text attribute" do
      body.should have_tag("input", :attributes => { :name => "q[body_contains]"})
    end

    it "should label a text field with search" do
      body.should have_tag('label', 'Search Body')
    end
  end

  describe "datetime attribute" do
    let(:body) { filter :created_at }

    it "should generate a date greater than" do
      body.should have_tag("input", :attributes => { :name => "q[created_at_gte]", :class => "datepicker"})
    end
    it "should generate a seperator" do
      body.should have_tag("span", :attributes => { :class => "seperator"})
    end
    it "should generate a date less than" do
      body.should have_tag("input", :attributes => { :name => "q[created_at_lte]", :class => "datepicker"})
    end
  end

  describe "integer attribute" do
    let(:body) { filter :id }

    it "should generate a select option for equal to" do
      body.should have_tag("option", "Equal To", :attributes => { :value => 'id_eq' })
    end
    it "should generate a select option for greater than" do
      body.should have_tag("option", "Greater Than")
    end
    it "should generate a select option for less than" do
      body.should have_tag("option", "Less Than")
    end
    it "should generate a text field for input" do
      body.should have_tag("input", :attributes => {
                                          :name => /q\[(id_eq|id_equals)\]/ })
    end
    it "should select the option which is currently being filtered"
  end

  describe "belong to" do
    before do
      @john = User.create :first_name => "John", :last_name => "Doe", :username => "john_doe"
      @jane = User.create :first_name => "Jane", :last_name => "Doe", :username => "jane_doe"
    end

    context "when given as the _id attribute name" do
      let(:body) { filter :author_id }

      it "should not render as an integer" do
        body.should_not have_tag("input", :attributes => {
                                                :name => "q[author_id_eq]"})
      end
      it "should render as belongs to select" do
        body.should have_tag("select", :attributes => {
                                            :name => "q[author_id_eq]"})
        body.should have_tag("option", "jane_doe", :attributes => {
                                                          :value => @jane.id })
      end
    end

    context "when given as the name of the relationship" do
      let(:body) { filter :author }

      it "should generate a select" do
        body.should have_tag("select", :attributes => {
                                            :name => "q[author_id_eq]"})
      end
      it "should set the default text to 'Any'" do
        body.should have_tag("option", "Any", :attributes => {
                                                    :value => "" })
      end
      it "should create an option for each related object" do
        body.should have_tag("option", "john_doe", :attributes => {
                                                          :value => @john.id })
        body.should have_tag("option", "jane_doe", :attributes => {
                                                          :value => @jane.id })
      end

      context "with a proc" do
        let :body do
          filter :title, :as => :select, :collection => proc{ ['Title One', 'Title Two'] }
        end

        it "should use call the proc as the collection" do
          body.should have_tag("option", "Title One")
          body.should have_tag("option", "Title Two")
        end
      end
    end

    context "as check boxes" do
      let(:body) { filter :author, :as => :check_boxes }

      it "should create a check box for each related object" do
        body.should have_tag("input", :attributes => {
                                            :name => "q[author_id_in][]",
                                            :type => "checkbox",
                                            :value => @john.id })
        body.should have_tag("input", :attributes => {
                                            :name => "q[author_id_in][]",
                                            :type => "checkbox",          
                                            :value => @jane.id })
      end
    end

    context "when polymorphic relationship" do
      let(:body) do
        search = ActiveAdmin::Comment.search
        active_admin_filters_form_for(search, [{ :attribute => :resource}])
      end
      it "should not generate any field" do
        body.should have_tag("form", :attributes => { :method => 'get' })
      end
    end
  end # belongs to
end
