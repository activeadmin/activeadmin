require 'spec_helper'

module ActiveAdmin
  describe Resource, "Naming" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    module ::Mock class Resource < ActiveRecord::Base; end; end
    module NoActiveModel class Resource; end; end

    describe "singular resource name" do
      context "when class" do
        it "should be the underscored singular resource name" do
          config.resource_name.singular.should == "category"
        end
      end
      context "when a class in a module" do
        it "should underscore the module and the class" do
          Resource.new(namespace, Mock::Resource).resource_name.singular.should == "mock_resource"
        end
      end
      context "when you pass the 'as' option" do
        it "should underscore the passed through string" do
          config(:as => "Blog Category").resource_name.singular.should == "blog_category"
        end
      end
    end

    describe "resource label" do
      it "should return a pretty name" do
        config.resource_label.should == "Category"
      end

      it "should return the plural version" do
        config.plural_resource_label.should == "Categories"
      end

      context "when the :as option is given" do
        it "should return the custom name" do
          config(:as => "My Category").resource_label.should == "My Category"
        end
      end

      context "when a class in a module" do
        it "should include the module and the class" do
          Resource.new(namespace, Mock::Resource).resource_label.should == "Mock Resource"
        end

        it "should include the module and the pluralized class" do
          Resource.new(namespace, Mock::Resource).plural_resource_label.should == "Mock Resources"
        end
      end

      describe "I18n integration" do
        describe "singular label" do
          it "should return the titleized model_name.human" do
            config.resource_name.should_receive(:human).and_return "Da category"

            config.resource_label.should == "Da category"
          end
        end

        describe "plural label" do
          it "should return the titleized plural version defined by i18n if available" do
            I18n.should_receive(:translate).at_least(:once).and_return("Da categories")
            config.plural_resource_label.should == "Da categories"
          end
        end

        context "when the :as option is given" do
          describe "singular label" do
            it "should return the translated custom name" do
              as_option = 'My Category'
              custom_config = config(:as => as_option)

              I18n.should_receive(:t).with(custom_config.resource_name.i18n_key, :scope => [ :activerecord, :models ], :default => as_option, :count => 1).and_return("Translated category")
              config(:as => as_option).resource_label.should == "Translated category"
            end
          end

          describe "plural label" do
            it "should return the translated custom pluralized name if available" do
              as_option = 'My Category'
              custom_config = config(:as => as_option)

              I18n.should_receive(:t).with(custom_config.resource_name.i18n_key, :scope => [ :activerecord, :models ], :default => as_option.pluralize, :count => 1.1).and_return("Translated categories")
              config(:as => as_option).plural_resource_label.should == "Translated categories"
            end
          end
        end

      end
    end

  end
end
