# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::FormHelper, type: :helper do
  def render_filter(search, filters)
    allow(helper).to receive(:collection_path).and_return("/posts")
    allow(helper).to receive(:a_helper_method).and_return("A Helper Method")
    render_arbre_component({ filter_args: [search, filters] }, helper) do
      args = assigns[:filter_args]
      kwargs = args.pop if args.last.is_a?(Hash)
      text_node active_admin_filters_form_for *args, **kwargs
    end.to_s
  end

  def filter(name, options = {})
    Capybara.string(render_filter(scope, name => options))
  end

  let(:scope) { Post.ransack }

  before do
    helper.class.send(:include, MethodOrProcHelper)
  end

  describe "the form in general" do
    let(:body) { filter :title }

    it "should generate a form which submits via get" do
      expect(body).to have_css("form.filters-form[method=get]")
    end

    it "should generate a filter button" do
      expect(body).to have_button('Filter')
    end

    it "should only generate the form once" do
      expect(body).to have_css("form", count: 1)
    end

    it "should generate a clear filters link" do
      expect(body).to have_link("Clear Filters", class: "filters-form-clear")
    end

    describe "label as proc" do
      let(:body) { filter :title, label: proc { "Title from proc" } }

      it "should render proper label" do
        expect(body).to have_css("label", text: "Title from proc")
      end
    end

    describe "input html as proc" do
      let(:body) { filter :title, as: :select, input_html: proc { { 'data-ajax-url': "/" } } }

      it "should render proper label" do
        expect(body).to have_css('select[data-ajax-url="/"]')
      end
    end
  end

  describe "string attribute" do
    let(:body) { filter :title }

    it "should generate a select option for starts with" do
      expect(body).to have_css("option[value=title_start]", text: "Starts with")
    end

    it "should generate a select option for ends with" do
      expect(body).to have_css("option[value=title_end]", text: "Ends with")
    end

    it "should generate a select option for contains" do
      expect(body).to have_css("option[value=title_cont]", text: "Contains")
    end

    it "should generate a text field for input" do
      expect(body).to have_field("q[title_cont]")
    end

    it "should have a proper label" do
      expect(body).to have_css("label", text: "Title")
    end

    it "should translate the label for text field" do
      with_translation %i[activerecord attributes post title], "Name" do
        expect(body).to have_css("label", text: "Name")
      end
    end

    it "should select the option which is currently being filtered" do
      scope = Post.ransack title_start: "foo"
      body = Capybara.string(render_filter scope, title: {})
      expect(body).to have_css("option[value=title_start][selected=selected]", text: "Starts with")
    end

    context "with filters options" do
      let(:body) { filter :title, filters: [:cont, :start] }

      it "should generate provided options for filter select" do
        expect(body).to have_css("option[value=title_cont]", text: "Contains")
        expect(body).to have_css("option[value=title_start]", text: "Starts with")
      end

      it "should not generate a select option for ends with" do
        expect(body).not_to have_css("option[value=title_end]")
      end
    end

    context "with predicate" do
      %w[eq cont start end].each do |predicate|
        describe "'#{predicate}'" do
          let(:body) { filter :"title_#{predicate}" }

          it "shouldn't include a select field" do
            expect(body).not_to have_select
          end

          it "should build correctly" do
            expect(body).to have_field("q[title_#{predicate}]")
          end
        end
      end
    end
  end

  describe "string attribute ended with ransack predicate" do
    let(:scope) { User.ransack }
    let(:body) { filter :reason_of_sign_in }

    it "should generate a select options" do
      expect(body).to have_css("option[value=reason_of_sign_in_start]")
      expect(body).to have_css("option[value=reason_of_sign_in_end]")
      expect(body).to have_css("option[value=reason_of_sign_in_cont]")
    end
  end

  describe "text attribute" do
    let(:body) { filter :body }

    it "should generate a search field for a text attribute" do
      expect(body).to have_field("q[body_cont]")
    end

    it "should have a proper label" do
      expect(body).to have_css("label", text: "Body")
    end
  end

  describe "string attribute, as a select" do
    let(:body) { filter :title, as: :select }
    let(:builder) { ActiveAdmin::Inputs::Filters::SelectInput }

    context "when loading collection from DB" do
      it "should use pluck for efficiency" do
        expect_any_instance_of(builder).to receive(:pluck_column) { [] }
        body
      end

      it "should remove original ordering to prevent PostgreSQL error" do
        expect(scope.object.klass).to receive(:reorder).with("title asc") {
          m = double distinct: double(pluck: ["A Title"])
          expect(m.distinct).to receive(:pluck).with :title
          m
        }
        body
      end

      context "and a statement timeout error occurs" do
        let(:body) { filter :title, as: :select, collection: ["foo"] }
        let(:input_super_class) { Formtastic::Inputs::Base::Collections }
        let(:db_timeout_exception) { ActiveRecord::QueryCanceled.new("ERROR: canceling statement due to statement timeout") }
        let(:expected_exception_message) { "ERROR: canceling statement due to statement timeout while querying the values for the ActiveAdmin :title filter" }

        before do
          expect_any_instance_of(input_super_class).to receive(:collection).and_raise(db_timeout_exception)
        end

        it "should raise a database timeout error with a message indicating which filter was the cause" do
          expect { body }.to raise_error(ActiveRecord::QueryCanceled, expected_exception_message)
        end
      end
    end
  end

  describe "date attribute" do
    let(:body) { filter :published_date }

    it "should generate a date greater than" do
      expect(body).to have_field("q[published_date_gteq]", class: "datepicker")
    end

    it "should generate a date less than" do
      expect(body).to have_field("q[published_date_lteq]", class: "datepicker")
    end

    it "should generate two inputs with different ids" do
      ids = body.find_css("input.datepicker").to_a.map { |n| n[:id] }
      expect(ids).to contain_exactly("q_published_date_lteq", "q_published_date_gteq")
    end

    it "should generate one label without for attribute" do
      label = body.find_css("label")
      expect(label.length).to be(1)
      expect(label.attr("for")).to be_nil
    end

    context "with input_html" do
      let(:body) { filter :published_date, input_html: { 'autocomplete': "off" } }

      it "should generate provided input html for both ends of date range" do
        expect(body).to have_css("input.datepicker[name='q[published_date_gteq]'][autocomplete=off]")
        expect(body).to have_css("input.datepicker[name='q[published_date_lteq]'][autocomplete=off]")
      end
    end

    context "with input_html overriding the defaults" do
      let(:body) { filter :published_date, input_html: { 'class': "custom_class" } }

      it "should override the default attribute values for both ends of date range" do
        expect(body).to have_field("q[published_date_gteq]", class: "custom_class")
        expect(body).to have_field("q[published_date_lteq]", class: "custom_class")
      end
    end
  end

  describe "datetime attribute" do
    let(:body) { filter :created_at }

    it "should generate a date greater than" do
      expect(body).to have_field("q[created_at_gteq]", class: "datepicker")
    end

    it "should generate a date less than" do
      expect(body).to have_field("q[created_at_lteq]", class: "datepicker")
    end

    context "with input_html" do
      let(:body) { filter :created_at, input_html: { 'autocomplete': "off" } }

      it "should generate provided input html for both ends of date range" do
        expect(body).to have_css("input.datepicker[name='q[created_at_gteq]'][autocomplete=off]")
        expect(body).to have_css("input.datepicker[name='q[created_at_lteq]'][autocomplete=off]")
      end
    end

    context "with input_html overriding the defaults" do
      let(:body) { filter :created_at, input_html: { 'class': "custom_class" } }

      it "should override the default attribute values for both ends of date range" do
        expect(body).to have_field("q[created_at_gteq]", class: "custom_class")
        expect(body).to have_field("q[created_at_lteq]", class: "custom_class")
      end
    end
  end

  describe "integer attribute" do
    context "without options" do
      let(:body) { filter :id }

      it "should generate a select option for equal to" do
        expect(body).to have_css("option[value=id_eq]", text: "Equals")
      end

      it "should generate a select option for greater than" do
        expect(body).to have_css("option[value=id_gt]", text: "Greater than")
      end

      it "should generate a select option for less than" do
        expect(body).to have_css("option[value=id_lt]", text: "Less than")
      end

      it "should generate a text field for input" do
        expect(body).to have_field("q[id_eq]")
      end

      it "should select the option which is currently being filtered" do
        scope = Post.ransack id_gt: 1
        body = Capybara.string(render_filter scope, id: {})
        expect(body).to have_css("option[value=id_gt][selected=selected]", text: "Greater than")
      end
    end

    context "with filters options" do
      let(:body) { filter :id, filters: [:eq, :gt] }

      it "should generate provided options for filter select" do
        expect(body).to have_css("option[value=id_eq]", text: "Equals")
        expect(body).to have_css("option[value=id_gt]", text: "Greater than")
      end

      it "should not generate a select option for less than" do
        expect(body).not_to have_css("option[value=id_lt]")
      end
    end
  end

  describe "boolean attribute" do
    context "boolean datatypes" do
      let(:body) { filter :starred }

      it "should generate a select" do
        expect(body).to have_select("q[starred_eq]")
      end

      it "should set the default text to 'Any'" do
        expect(body).to have_css("option[value='']", text: "Any")
      end

      it "should create an option for true and false" do
        expect(body).to have_css("option[value=true]", text: "Yes")
        expect(body).to have_css("option[value=false]", text: "No")
      end

      it "should translate the label for boolean field" do
        with_translation %i[activerecord attributes post starred], "Faved" do
          expect(body).to have_css("label", text: "Faved")
        end
      end
    end

    context "non-boolean data types" do
      let(:body) { filter :title_present, as: :boolean }

      it "should generate a select" do
        expect(body).to have_select("q[title_present]")
      end

      it "should set the default text to 'Any'" do
        expect(body).to have_css("option[value='']", text: "Any")
      end

      it "should create an option for true and false" do
        expect(body).to have_css("option[value=true]", text: "Yes")
        expect(body).to have_css("option[value=false]", text: "No")
      end
    end
  end

  describe "belongs_to" do
    before do
      @john = User.create first_name: "John", last_name: "Doe", username: "john_doe"
      @jane = User.create first_name: "Jane", last_name: "Doe", username: "jane_doe"
    end

    context "when given as the _id attribute name" do
      let(:body) { filter :author_id }

      it "should generate a numeric filter" do
        expect(body).to have_css("label", text: "Author") # really this should be Author ID :/)
        expect(body).to have_css("option[value=author_id_lt]")
        expect(body).to have_field("q[author_id_eq]", id: "q_author_id")
      end
    end

    context "when given as the name of the relationship" do
      let(:body) { filter :author }

      it "should generate a select" do
        expect(body).to have_select("q[author_id_eq]")
      end

      it "should set the default text to 'Any'" do
        expect(body).to have_css("option[value='']", text: "Any")
      end

      it "should create an option for each related object" do
        expect(body).to have_selector("option[value='#{@john.id}']", text: "John Doe")
        expect(body).to have_selector("option[value='#{@jane.id}']", text: "Jane Doe")
      end

      context "with a proc" do
        let :body do
          filter :title, as: :select, collection: proc { ["Title One", "Title Two"] }
        end

        it "should use call the proc as the collection" do
          expect(body).to have_css("option", text: "Title One")
          expect(body).to have_css("option", text: "Title Two")
        end

        it "should render the collection in the context of the view" do
          body = filter :title, as: :select, collection: proc { [a_helper_method] }
          expect(body).to have_css("option", text: "A Helper Method")
        end
      end
    end

    context "when given the name of relationship with a primary key other than id" do
      let(:resource_klass) do
        Class.new(Post) do
          belongs_to :kategory, class_name: "Category", primary_key: :name, foreign_key: :title

          def self.name
            "SuperPost"
          end
        end
      end

      let(:scope) do
        resource_klass.ransack
      end

      let(:body) { filter :kategory }

      it "should use the association primary key" do
        expect(body).to have_select("q[kategory_name_eq]")
      end
    end

    context "as check boxes" do
      let(:body) { filter :author, as: :check_boxes }

      it "should create a check box for each related object" do
        expect(body).to have_field("q[author_id_in][]", type: :checkbox, with: @jane.id)
        expect(body).to have_field("q[author_id_in][]", type: :checkbox, with: @jane.id)
      end
    end

    context "when polymorphic relationship" do
      let(:scope) { ActiveAdmin::Comment.ransack }
      it "should raise an error if a collection isn't provided" do
        expect { filter :resource }.to raise_error \
          Formtastic::PolymorphicInputWithoutCollectionError
      end
    end

    context "when using a custom foreign key" do
      let(:scope) { Post.ransack }
      let(:body) { filter :category }
      it "should ignore that foreign key and let Ransack handle it" do
        expect(Post.reflect_on_association(:category).foreign_key.to_sym).to eq :custom_category_id
        expect(body).to have_select("q[category_id_eq]")
      end
    end
  end # belongs to

  describe "has_and_belongs_to_many" do
    # skip "add HABTM models so this can be tested"
  end

  describe "has_many :through" do
    let(:scope) { Category.ransack }

    let!(:john) { User.create first_name: "John", last_name: "Doe", username: "john_doe" }
    let!(:jane) { User.create first_name: "Jane", last_name: "Doe", username: "jane_doe" }

    context "when given as the name of the relationship" do
      let(:body) { filter :authors }

      it "should generate a select" do
        expect(body).to have_select("q[posts_author_id_eq]")
      end

      it "should set the default text to 'Any'" do
        expect(body).to have_css("option[value='']", text: "Any")
      end

      it "should create an option for each related object" do
        expect(body).to have_selector("option[value='#{john.id}']", text: "John Doe")
        expect(body).to have_selector("option[value='#{jane.id}']", text: "Jane Doe")
      end
    end

    context "as check boxes" do
      let(:body) { filter :authors, as: :check_boxes }

      it "should create a check box for each related object" do
        expect(body).to have_field("q[posts_author_id_in][]", type: "checkbox", with: john.id)
        expect(body).to have_field("q[posts_author_id_in][]", type: "checkbox", with: jane.id)
      end
    end
  end

  describe "conditional display" do
    [:if, :unless].each do |verb|
      should = verb == :if ? "should" : "shouldn't"
      if_true = verb == :if ? :to : :to_not
      if_false = verb == :if ? :to_not : :to
      context "with #{verb.inspect} proc" do
        it "#{should} be displayed if true" do
          body = filter :body, verb => proc { true }
          expect(body).send if_true, have_field("q[body_cont]")
        end

        it "#{should} be displayed if false" do
          body = filter :body, verb => proc { false }
          expect(body).send if_false, have_field("q[body_cont]")
        end

        it "should still be hidden on the second render" do
          filters = { body: { verb => proc { verb == :unless } } }
          2.times do
            body = Capybara.string(render_filter scope, filters)
            expect(body).not_to have_field("q[body_cont]")
          end
        end

        it "should successfully keep rendering other filters after one is hidden" do
          filters = { body: { verb => proc { verb == :unless } }, author: {} }
          body = Capybara.string(render_filter scope, filters)
          expect(body).not_to have_field("q[body_cont]")
          expect(body).to have_select("q[author_id_eq]")
        end
      end
    end
  end

  describe "custom search methods" do
    it "should use the default type of the ransacker" do
      body = filter :custom_searcher_numeric
      expect(body).to have_css("option[value=custom_searcher_numeric_eq]")
      expect(body).to have_css("option[value=custom_searcher_numeric_gt]")
      expect(body).to have_css("option[value=custom_searcher_numeric_lt]")
    end

    it "should work as select" do
      body = filter :custom_title_searcher, as: :select, collection: ["foo"]
      expect(body).to have_select("q[custom_title_searcher_eq]")
    end

    it "should work as string" do
      body = filter :custom_title_searcher, as: :string
      expect(body).to have_css("option[value=custom_title_searcher_cont]")
      expect(body).to have_css("option[value=custom_title_searcher_start]")
    end

    describe "custom date range search" do
      let(:gteq) { "2010-10-01" }
      let(:lteq) { "2010-10-02" }
      let(:scope) { Post.ransack custom_created_at_searcher_gteq: gteq, custom_created_at_searcher_lteq: lteq }
      let(:body) { filter :custom_created_at_searcher, as: :date_range }

      it "should work as date_range" do
        expect(body).to have_field("q[custom_created_at_searcher_gteq]", with: "2010-10-01")
        expect(body).to have_field("q[custom_created_at_searcher_lteq]", with: "2010-10-02")
      end

      context "filter value can't be casted to date" do
        let(:gteq) { "Ooops" }
        let(:lteq) { "Ooops" }

        it "should work display empty filter values" do
          expect(body).to have_field("q[custom_created_at_searcher_gteq]", with: "")
          expect(body).to have_field("q[custom_created_at_searcher_lteq]", with: "")
        end
      end
    end
  end

  describe "does not support some filter inputs" do
    it "should fallback to use formtastic inputs" do
      body = filter :custom_title_searcher, as: :text
      expect(body).to have_css("textarea[name='q[custom_title_searcher]']")
    end
  end

  describe "blank option" do
    context "for a select filter" do
      it "should be there by default" do
        body = filter :author
        expect(body).to have_css("option", text: "Any")
      end

      it "should be able to be disabled" do
        body = filter :author, include_blank: false
        expect(body).to_not have_css("option", text: "Any")
      end
    end

    context "for a multi-select filter" do
      it "should not be there by default" do
        body = filter :author, multiple: true
        expect(body).to_not have_css("option", text: "Any")
      end

      it "should be able to be enabled" do
        body = filter :author, multiple: true, include_blank: true
        expect(body).to have_css("option", text: "Any")
      end
    end
  end
end
