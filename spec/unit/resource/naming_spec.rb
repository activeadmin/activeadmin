require 'spec_helper'

module ActiveAdmin
  describe Resource, "Naming" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end


    describe "underscored resource name" do
      context "when class" do
        it "should be the underscored singular resource name" do
          config.underscored_resource_name.should == "category"
        end
      end
      context "when a class in a module" do
        it "should underscore the module and the class" do
          module ::Mock; class Resource; end; end
          Resource.new(namespace, Mock::Resource).underscored_resource_name.should == "mock_resource"
        end
      end
      context "when you pass the 'as' option" do
        it "should underscore the passed through string and singulralize" do
          config(:as => "Blog Categories").underscored_resource_name.should == "blog_category"
        end
      end
    end

    describe "camelized resource name" do
      it "should return a camelized version of the underscored resource name" do
        config(:as => "Blog Categories").camelized_resource_name.should == "BlogCategory"
      end
    end
    
    describe "plural underscored resource name" do
      before(:all) do
        class ::CandyCane; end
        @config = Resource.new(namespace, CandyCane, {})
      end
      
      it "should return an underscored and pluralized resource name" do
        config.plural_underscored_resource_name.should == "candy_canes"
      end
    end

    describe "resource name" do
      it "should return a pretty name" do
        config.resource_name.should == "Category"
      end
      it "should return the plural version" do
        config.plural_resource_name.should == "Categories"
      end
      context "when the :as option is given" do
        it "should return the custom name" do
          config(:as => "My Category").resource_name.should == "My Category"
        end
      end
      context "I18n" do
        before do
          I18n.stub(:translate) { 'Categorie' }
        end
        it "should return the plural version defined in the i18n if available" do
          config.plural_resource_name.should == "Categorie"
        end
      end
    end

  end
end
