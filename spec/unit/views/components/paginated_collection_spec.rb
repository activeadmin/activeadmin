require 'rails_helper'

RSpec.describe ActiveAdmin::Views::PaginatedCollection do
  describe "creating with the dsl" do

    before :all do
      load_defaults!
      reload_routes!
    end

    let(:view) do
      view = mock_action_view
      allow(view.request).to receive(:query_parameters).and_return page: '1'
      allow(view.request).to receive(:path_parameters).and_return  controller: 'admin/posts', action: 'index'
      view
    end

    # Helper to render paginated collections within an arbre context
    def paginated_collection(*args)
      render_arbre_component({paginated_collection_args: args}, view) do
        paginated_collection(*paginated_collection_args)
      end
    end

    let(:collection) do
      posts = [Post.new(title: "First Post"), Post.new(title: "Second Post"), Post.new(title: "Third Post")]
      Kaminari.paginate_array(posts).page(1).per(5)
    end

    before do
      allow(collection).to receive(:except) { collection } unless collection.respond_to? :except
      allow(collection).to receive(:group_values) { [] }   unless collection.respond_to? :group_values
    end

    let(:pagination){ paginated_collection collection }

    it "should set :collection as the passed in collection" do
      expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>all 3</b> posts"
    end

    it "should raise error if collection has no pagination scope" do
      expect {
        paginated_collection([Post.new, Post.new])
      }.to raise_error(StandardError, "Collection is not a paginated scope. Set collection.page(params[:page]).per(10) before calling :paginated_collection.")
    end

    it 'should preserve custom query params' do
      allow(view.request).to receive(:query_parameters).and_return page: '1', something: 'else'
      pagination_content = pagination.content
      expect(pagination_content).to include '/admin/posts.csv?page=1&amp;something=else'
      expect(pagination_content).to include '/admin/posts.xml?page=1&amp;something=else'
      expect(pagination_content).to include '/admin/posts.json?page=1&amp;something=else'
    end

    context "when specifying :param_name option" do
      let(:collection) do
        posts = 10.times.map{ Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, param_name: :post_page) }

      it "should customize the page number parameter in pagination links" do
        expect(pagination.children.last.content).to match(/\/admin\/posts\?post_page=2/)
      end
    end

    context "when specifying :params option" do
      let(:collection) do
        posts = 10.times.map{ Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, param_name: :post_page, params: { anchor: 'here' }) }

      it "should pass it through to Kaminari" do
        expect(pagination.children.last.content).to match(/\/admin\/posts\?post_page=2#here/)
      end
    end

    context "when specifying download_links: false option" do
      let(:collection) do
        posts = 10.times.map{ Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, download_links: false) }

      it "should not render download links" do
        expect(pagination.find_by_tag('div').last.content).to_not match(/Download:/)
      end
    end

    context "when specifying :entry_name option with a single item" do
      let(:collection) do
        posts = [Post.new]
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, entry_name: "message") }

      it "should use :entry_name as the collection name" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>1</b> message"
      end
    end

    context "when specifying :entry_name option with multiple items" do
      let(:pagination) { paginated_collection(collection, entry_name: "message") }

      it "should use :entry_name as the collection name" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>all 3</b> messages"
      end
    end

    context "when specifying :entry_name and :entries_name option with a single item" do
      let(:collection) do
        posts = [Post.new]
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, entry_name: "singular", entries_name: "plural") }

      it "should use :entry_name as the collection name" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>1</b> singular"
      end
    end

    context "when specifying :entry_name and :entries_name option with a multiple items" do
      let(:pagination) { paginated_collection(collection, entry_name: "singular", entries_name: "plural") }

      it "should use :entries_name as the collection name" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>all 3</b> plural"
      end
    end

    context "when omitting :entry_name with a single item" do
      let(:collection) do
        posts = [Post.new]
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      it "should use 'post' as the collection name when there is no I18n translation" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>1</b> post"
      end

      it "should use 'Singular' as the collection name when there is an I18n translation" do
        allow(I18n).to receive(:translate) { "Singular" }
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>1</b> Singular"
      end
    end

    context "when omitting :entry_name with multiple items" do
      it "should use 'posts' as the collection name when there is no I18n translation" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>all 3</b> posts"
      end

      it "should use 'Plural' as the collection name when there is an I18n translation" do
        allow(I18n).to receive(:translate) { "Plural" }
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>all 3</b> Plural"
      end
    end

    context "when specifying an empty collection" do
      let(:collection) do
        posts = []
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      it "should display 'No entries found'" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "No entries found"
      end
    end

    context "when collection comes from find with GROUP BY" do
      let(:collection) do
        %w{Foo Foo Bar}.each {|title| Post.create(title: title) }
        Post.select(:title).group(:title).page(1).per(5)
      end

      it "should display proper message (including number and not hash)" do
        expect(pagination.find_by_class('pagination_information').first.content).to eq "Displaying <b>all 2</b> posts"
      end
    end

    context "when collection with many pages comes from find with GROUP BY" do
      let(:collection) do
        %w{Foo Foo Bar Baz}.each {|title| Post.create(title: title) }
        Post.select(:title).group(:title).page(1).per(2)
      end

      it "should display proper message (including number and not hash)" do
        expect(pagination.find_by_class('pagination_information').first.content.gsub('&nbsp;', ' ')).
          to eq "Displaying posts <b>1 - 2</b> of <b>3</b> in total"
      end
    end

    context "when viewing the last page of a collection that has multiple pages" do
      let(:collection) do
        Kaminari.paginate_array([Post.new] * 81).page(3).per(30)
      end

      it "should show the proper item counts" do
        expect(pagination.find_by_class('pagination_information').first.content.gsub('&nbsp;', ' ')).
          to eq "Displaying posts <b>61 - 81</b> of <b>81</b> in total"
      end
    end

    context "with :pagination_total" do
      let(:collection) do
        Kaminari.paginate_array([Post.new] * 256).page(1).per(30)
      end

      describe "set to false" do
        it "should not show the total item counts" do
          expect(collection).not_to receive(:total_pages)
          pagination = paginated_collection(collection, pagination_total: false)
          info = pagination.find_by_class('pagination_information').first.content.gsub('&nbsp;', ' ')
          expect(info).to eq "Displaying posts <b>1 - 30</b>"
        end
      end

      describe "set to true" do
        let(:pagination) { paginated_collection(collection, pagination_total: true) }

        it "should show the total item counts" do
          info = pagination.find_by_class('pagination_information').first.content.gsub('&nbsp;', ' ')
          expect(info).to eq "Displaying posts <b>1 - 30</b> of <b>256</b> in total"
        end
      end
    end

    context "when specifying per_page: array option" do
      let(:collection) do
        posts = 10.times.map { Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, per_page: [1, 2, 3]) }
      let(:pagination_html) { pagination.find_by_class("pagination_per_page").first }
      let(:pagination_node) { Capybara.string(pagination_html.to_s) }

      it "should render per_page select tag" do
        expect(pagination_html.content).to match(/Per page:/)
        expect(pagination_node).to have_css("select option", count: 3)
      end
    end

  end
end
