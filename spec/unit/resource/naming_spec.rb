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
        it "should underscore the passed through string" do
          config(:as => "Blog Category").underscored_resource_name.should == "blog_category"
        end
      end
    end

    describe "camelized resource name" do
      it "should return a camelized version of the underscored resource name" do
        config(:as => "Blog category").camelized_resource_name.should == "BlogCategory"
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

      describe "I18n integration" do
        describe "singular name" do
          it "should return the titleized model_name.human" do
            Category.model_name.should_receive(:human).and_return "Da category"

            config.resource_name.should == "Da Category"
          end
        end

        describe "plural name" do
          it "should return the titleized plural version defined by i18n if available" do
            Category.model_name.should_receive(:underscore).and_return "category"
            Category.model_name.should_not_receive(:i18n_key) # Not implemented in Rails 3.0.0
            I18n.should_receive(:translate!).
              with("activerecord.models.category.other").
              and_return("Da categories")
            config.plural_resource_name.should == "Da Categories"
          end
        end

      end
    end

  end
end
