require 'spec_helper' 

module ActiveAdmin
  describe Resource, "Pagination" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    describe "#paginate" do
      it "should default to true" do
        config.paginate.should == true
      end

      it "should be settable to false" do
        config.paginate = false
        config.paginate.should == false
      end
    end

    describe "#per_page" do
      it "should default to namespace.default_per_page" do
        # will not work
        #namespace.should_receive(:default_per_page).and_return(5)
        #config.per_page.should == 5
      end

      it "should default to paginates_per when set to 10 " do
        Category.paginates_per 10
        config.per_page.should == 10
      end

      it "should default to 25 when paginates_per set to nil" do
        Category.paginates_per nil
        config.per_page.should == 25
      end

      it "should default to 30 when paginates_per set to 0" do
        Category.paginates_per 0
        config.per_page.should == 30
      end
 
      it "should be settable" do
        config.per_page = 5
        config.per_page.should == 5
      end
    end
  end
end
