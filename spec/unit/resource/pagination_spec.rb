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
        namespace.should_receive(:default_per_page).and_return(5)
        config.per_page.should == 5
      end

      it "should be settable" do
        config.per_page = 5
        config.per_page.should == 5
      end
    end
  end
end
