require 'spec_helper'

class Post
  ransacker :custom_searcher do
    # nothing to see here
  end
end

describe ActiveAdmin::Filters::ViewHelper do

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

    def view.a_helper_method
      "A Helper Method"
    end

    view
  end

  def render_filter(search, filters)
    render_arbre_component({filter_args: [search, filters]}, helpers) do
      text_node active_admin_filters_form_for *assigns[:filter_args]
    end
  end

  def filter(name, options = {})
    render_filter scope, name => options
  end

  let(:scope) { Post.search }

  describe "the form in general" do
    let(:body) { filter :title }

    it "should generate a form which submits via get" do
      expect(body).to have_tag("form", attributes: { method: 'get', class: 'filter_form' })
    end

    it "should generate a filter button" do
      expect(body).to have_tag("input", attributes: { type: "submit",
                                                        value: "Filter" })
    end

    it "should only generate the form once" do
      expect(body.to_s.scan(/q\[title_contains\]/).size).to eq 1
    end

    it "should generate a clear filters link" do
      expect(body).to have_tag("a", "Clear Filters", attributes: { class: "clear_filters_btn" })
    end

    describe "label as proc" do
      let(:body) { filter :title, label: proc { 'Title from proc' } }

      it "should render proper label" do
        expect(body).to have_tag('label', 'Title from proc')
      end
    end
  end

  describe "string attribute" do
    let(:body) { filter :title }

    it "should generate a select option for starts with" do
      expect(body).to have_tag("option", "Starts with", attributes: { value: 'title_starts_with' })
    end

    it "should generate a select option for ends with" do
      expect(body).to have_tag("option", "Ends with", attributes: { value: 'title_ends_with' })
    end

    it "should generate a select option for contains" do
      expect(body).to have_tag("option", "Contains", attributes: { value: 'title_contains' })
    end

    it "should generate a text field for input" do
      expect(body).to have_tag("input", attributes: { name: 'q[title_contains]' })
    end

    it "should have a proper label" do
      expect(body).to have_tag('label', 'Title')
    end

    it "should translate the label for text field" do
      with_translation activerecord: {attributes: {post: {title: 'Name'}}} do
        expect(body).to have_tag('label', 'Name')
      end
    end

    it "should select the option which is currently being filtered"


    context "with predicate" do
      %w[eq equals cont contains start starts_with end ends_with].each do |predicate|
        describe '"'+predicate+'"' do
          let(:body) { filter :"title_#{predicate}" }

          it "shouldn't include a select field" do
            expect(body).not_to have_tag "select"
          end

          it "should build correctly" do
            expect(body).to have_tag("input", attributes: { name: "q[title_#{predicate}]" })
          end
        end
      end
    end
  end

  describe "text attribute" do
    let(:body) { filter :body }

    it "should generate a search field for a text attribute" do
      expect(body).to have_tag("input", attributes: { name: "q[body_contains]"})
    end

    it "should have a proper label" do
      expect(body).to have_tag('label', 'Body')
    end
  end

  describe "string attribute, as a select" do
    let(:body) { filter :title, as: :select }
    let(:builder) { ActiveAdmin::Inputs::FilterSelectInput }

    context "when loading collection from DB" do
      it "should use pluck for efficiency" do
        expect_any_instance_of(builder).to receive(:pluck_column) { [] }
        body
      end

      it "should remove original ordering to prevent PostgreSQL error" do
        expect(scope.object.klass).to receive(:reorder).with('title asc') {
          m = double uniq: double(pluck: ['A Title'])
          expect(m.uniq).to receive(:pluck).with :title
          m
        }
        body
      end
    end
  end

  describe "datetime attribute" do
    let(:body) { filter :created_at }

    it "should generate a date greater than" do
      expect(body).to have_tag("input", attributes: { name: "q[created_at_gteq]", class: "datepicker"})
    end
    it "should generate a seperator" do
      expect(body).to have_tag("span", attributes: { class: "seperator"})
    end
    it "should generate a date less than" do
      expect(body).to have_tag("input", attributes: { name: "q[created_at_lteq]", class: "datepicker"})
    end
  end

  describe "integer attribute" do
    let(:body) { filter :id }

    it "should generate a select option for equal to" do
      expect(body).to have_tag("option", "Equals", attributes: { value: 'id_equals' })
    end
    it "should generate a select option for greater than" do
      expect(body).to have_tag("option", "Greater than")
    end
    it "should generate a select option for less than" do
      expect(body).to have_tag("option", "Less than")
    end
    it "should generate a text field for input" do
      expect(body).to have_tag("input", attributes: { name: 'q[id_equals]' })
    end
    it "should select the option which is currently being filtered"
  end

  describe "boolean attribute" do
    context "boolean datatypes" do
      let(:body) { filter :starred }

      it "should create a check box for equals to" do
        expect(body).to have_tag("input", attributes: {
                                            name: "q[starred_eq]",
                                            type: "checkbox" })
      end

      it "should translate the label for boolean field" do
        with_translation activerecord: {attributes: {post: {starred: 'Faved'}}} do
          expect(body).to have_tag('label', 'Faved')
        end
      end
    end

    context "non-boolean data types" do
      let(:body) { filter :title_present, as: :boolean }

      it "should create a check box for equals to" do
        expect(body).to have_tag("input", attributes: {
                                            name: "q[title_present]",
                                            type: "checkbox" })
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
        expect(body).to have_tag 'label', 'Author' # really this should be Author ID :/
        expect(body).to have_tag 'option', attributes: { value: 'author_id_less_than' }
        expect(body).to have_tag 'input',  attributes: { id: 'q_author_id', name: 'q[author_id_equals]'}
      end
    end

    context "when given as the name of the relationship" do
      let(:body) { filter :author }

      it "should generate a select" do
        expect(body).to have_tag "select",             attributes: { name: "q[author_id_eq]" }
      end
      it "should set the default text to 'Any'" do
        expect(body).to have_tag "option", "Any",      attributes: { value: "" }
      end
      it "should create an option for each related object" do
        expect(body).to have_tag "option", "John Doe", attributes: { value: @john.id }
        expect(body).to have_tag "option", "Jane Doe", attributes: { value: @jane.id }
      end

      context "with a proc" do
        let :body do
          filter :title, as: :select, collection: proc{ ['Title One', 'Title Two'] }
        end

        it "should use call the proc as the collection" do
          expect(body).to have_tag("option", "Title One")
          expect(body).to have_tag("option", "Title Two")
        end

        it "should render the collection in the context of the view" do
          body = filter(:title, as: :select, collection: proc{[a_helper_method]})
          expect(body).to have_tag("option", "A Helper Method")
        end
      end
    end

    context "as check boxes" do
      let(:body) { filter :author, as: :check_boxes }

      it "should create a check box for each related object" do
        expect(body).to have_tag("input", attributes: {
                                            name: "q[author_id_in][]",
                                            type: "checkbox",
                                            value: @john.id })
        expect(body).to have_tag("input", attributes: {
                                            name: "q[author_id_in][]",
                                            type: "checkbox",
                                            value: @jane.id })
      end
    end

    context "when polymorphic relationship" do
      let(:scope) { ActiveAdmin::Comment.search }
      it "should raise an error if a collection isn't provided" do
        expect { filter :resource }.to raise_error \
          Formtastic::PolymorphicInputWithoutCollectionError
      end
    end

    context "when using a custom foreign key" do
      let(:scope) { Post.search }
      let(:body)  { filter :category }
      it "should should ignore that foreign key and let Ransack handle it" do
        expect(Post.reflections[:category].foreign_key).to eq :custom_category_id
        expect(body).to have_tag "select", attributes: { name: "q[category_id_eq]" }
      end
    end
  end # belongs to

  describe "has_and_belongs_to_many" do
    pending "add HABTM models so this can be tested"
  end

  describe "has_many :through" do
    # Setup an ActionView::Base object which can be used for
    # generating the form for.
    let(:helpers) do
      view = action_view
      def view.collection_path
        "/categories"
      end

      def view.protect_against_forgery?
        false
      end

      def view.a_helper_method
        "A Helper Method"
      end

      view
    end
    let(:scope) { Category.search }

    let!(:john) { User.create first_name: "John", last_name: "Doe", username: "john_doe" }
    let!(:jane) { User.create first_name: "Jane", last_name: "Doe", username: "jane_doe" }

    context "when given as the name of the relationship" do
      let(:body) { filter :authors }

      it "should generate a select" do
        expect(body).to have_tag 'select', attributes: { name: "q[posts_author_id_eq]" }
      end

      it "should set the default text to 'Any'" do
        expect(body).to have_tag "option", "Any", attributes: { value: "" }
      end

      it "should create an option for each related object" do
        expect(body).to have_tag "option", "John Doe", attributes: { value: john.id }
        expect(body).to have_tag "option", "Jane Doe", attributes: { value: jane.id }
      end
    end

    context "as check boxes" do
      let(:body) { filter :authors, as: :check_boxes }

      it "should create a check box for each related object" do
        expect(body).to have_tag("input", attributes: {
                                            name: "q[posts_author_id_in][]",
                                            type: "checkbox",
                                            value: john.id })
        expect(body).to have_tag("input", attributes: {
                                            name: "q[posts_author_id_in][]",
                                            type: "checkbox",
                                            value: jane.id })
      end
    end
  end

  describe "conditional display" do
    [:if, :unless].each do |verb|
      should   = verb == :if ? "should" : "shouldn't"
      if_true  = verb == :if ? :to      : :to_not
      if_false = verb == :if ? :to_not  : :to
      context "with #{verb.inspect} proc" do
        it "#{should} be displayed if true" do
          body = filter :body, verb => proc{ true }
          expect(body).send if_true,  have_tag("input", attributes: {name: "q[body_contains]"})
        end
        it "#{should} be displayed if false" do
          body = filter :body, verb => proc{ false }
          expect(body).send if_false, have_tag("input", attributes: {name: "q[body_contains]"})
        end
        it "should still be hidden on the second render" do
          filters = {body: { verb => proc{ verb == :unless }}}
          2.times do
            body = render_filter scope, filters
            expect(body).not_to have_tag "input", attributes: {name: "q[body_contains]"}
          end
        end
        it "should successfully keep rendering other filters after one is hidden" do
          filters = {body: { verb => proc{ verb == :unless }}, author: {}}
          body    = render_filter scope, filters
          expect(body).not_to have_tag "input",  attributes: {name: "q[body_contains]"}
          expect(body).to     have_tag "select", attributes: {name: "q[author_id_eq]"}
        end
      end
    end
  end

  describe "custom search methods" do

    it "should work as select" do
      body = filter :custom_searcher, as: :select, collection: ['foo']
      expect(body).to have_tag "select", attributes: { name: "q[custom_searcher]" }
    end

    it "should work as string" do
      body = filter :custom_searcher, as: :string
      expect(body).to have_tag "input", attributes: { name: "q[custom_searcher]" }
    end
  end

  describe "blank option" do
    context "for a select filter" do
      it "should be there by default" do
        expect(filter(:author)).to have_tag "option", "Any"
      end
      it "should be able to be disabled" do
        expect(filter(:author, include_blank: false)).to_not have_tag "option", "Any"
      end
    end

    context "for a multi-select filter" do
      it "should not be there by default" do
        expect(filter(:author, multiple: true)).to_not have_tag "option", "Any"
      end
      it "should be able to be enabled" do
        expect(filter(:author, multiple: true, include_blank: true)).to have_tag "option", "Any"
      end
    end
  end

end
