require 'spec_helper'

describe ActiveAdmin::Views::PaginatedCollection do
  describe "creating with the dsl" do
    setup_arbre_context!

    let(:collection) do
      posts = [Post.new(:title => "First Post"), Post.new(:title => "Second Post"), Post.new(:title => "Third Post")]
      Kaminari.paginate_array(posts).page(1).per(5)
    end

    before do
      request.stub!(:query_parameters).and_return({:controller => 'admin/posts', :action => 'index', :page => '1'})
      controller.params = {:controller => 'admin/posts', :action => 'index'}
    end

    context "when specifying collection" do
      let(:pagination) do
        paginated_collection(collection)
      end

      it "should set :collection as the passed in collection" do
        pagination.find_by_class('pagination_information').first.content.should == "Displaying <b>all 3</b> posts"
      end

      it "should raise error if collection has no pagination scope" do
        lambda {
          paginated_collection([Post.new, Post.new])
        }.should raise_error(StandardError, "Collection is not a paginated scope. Set collection.page(params[:page]).per(10) before calling :paginated_collection.")
      end
    end

    context "when specifying :param_name option" do
      let(:collection) do
        posts = 10.times.inject([]) {|m, _| m << Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, :param_name => :post_page) }

      it "should customize the page number parameter in pagination links" do
        pagination.find_by_class('pagination_information').first.content.should match(/\/admin\/posts\?post_page=2/)
      end
    end

    context "when specifying :download_links => false option" do
      let(:collection) do
        posts = 10.times.inject([]) {|m, _| m << Post.new }
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, :download_links => false) }

      it "should not render download links" do
        pagination.find_by_tag('div').last.content.should_not match(/Download:/)
      end
    end

    context "when specifying :entry_name option with a single item" do
      let(:collection) do
        posts = [Post.new]
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, :entry_name => "message") }

      it "should use :entry_name as the collection name" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>1</b> message"
      end
    end

    context "when specifying :entry_name option with multiple items" do
      let(:pagination) { paginated_collection(collection, :entry_name => "message") }

      it "should use :entry_name as the collection name" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>all 3</b> messages"
      end
    end

    context "when specifying :entry_name and :entries_name option with a single item" do
      let(:collection) do
        posts = [Post.new]
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection, :entry_name => "singular", :entries_name => "plural") }

      it "should use :entry_name as the collection name" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>1</b> singular"
      end
    end

    context "when specifying :entry_name and :entries_name option with a multiple items" do
      let(:pagination) { paginated_collection(collection, :entry_name => "singular", :entries_name => "plural") }

      it "should use :entries_name as the collection name" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>all 3</b> plural"
      end
    end

    context "when omitting :entry_name with a single item" do
      let(:collection) do
        posts = [Post.new]
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection) }

      it "should use 'post' as the collection name when there is no I18n translation" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>1</b> post"
      end

      it "should use 'Singular' as the collection name when there is an I18n translation" do
        I18n.stub(:translate!) { "Singular" }
        pagination.find_by_tag('div').first.content.should == "Displaying <b>1</b> Singular"
      end
    end

    context "when omitting :entry_name with multiple items" do
      let(:pagination) { paginated_collection(collection) }

      it "should use 'posts' as the collection name when there is no I18n translation" do
        pagination.find_by_tag('div').first.content.should == "Displaying <b>all 3</b> posts"
      end

      it "should use 'Plural' as the collection name when there is an I18n translation" do
        I18n.stub(:translate!) { "Plural" }
        pagination.find_by_tag('div').first.content.should == "Displaying <b>all 3</b> Plural"
      end
    end

    context "when specifying an empty collection" do
      let(:collection) do
        posts = []
        Kaminari.paginate_array(posts).page(1).per(5)
      end

      let(:pagination) { paginated_collection(collection) }

      it "should display 'No entries found'" do
        pagination.find_by_tag('div').first.content.should == "No entries found"
      end
    end
  end
end
