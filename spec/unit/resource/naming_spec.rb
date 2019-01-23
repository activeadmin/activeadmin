require 'rails_helper'

module ActiveAdmin
  RSpec.describe Resource, "Naming" do
    let(:application) { ActiveAdmin::Application.new }
    let(:namespace) { Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    module ::Mock class Resource < ActiveRecord::Base; end; end
    module NoActiveModel class Resource; end; end

    describe "singular resource name" do
      context "when class" do
        it "should be the underscored singular resource name" do
          expect(config.resource_name.singular).to eq "category"
        end
      end
      context "when a class in a module" do
        it "should underscore the module and the class" do
          expect(Resource.new(namespace, Mock::Resource).resource_name.singular).to eq "mock_resource"
        end
      end
      context "when you pass the 'as' option" do
        it "should underscore the passed through string" do
          expect(config(as: "Blog Category").resource_name.singular).to eq "blog_category"
        end
      end
    end

    describe "resource label" do
      it "should return a pretty name" do
        expect(config.resource_label).to eq "Category"
      end

      it "should return the plural version" do
        expect(config.plural_resource_label).to eq "Categories"
      end

      context "when the :as option is given" do
        it "should return the custom name" do
          expect(config(as: "My Category").resource_label).to eq "My Category"
        end
      end

      context "when a class in a module" do
        it "should include the module and the class" do
          expect(Resource.new(namespace, Mock::Resource).resource_label).to eq "Mock Resource"
        end

        it "should include the module and the pluralized class" do
          expect(Resource.new(namespace, Mock::Resource).plural_resource_label).to eq "Mock Resources"
        end
      end

      describe "I18n integration" do
        describe "singular label" do
          it "should return the titleized model_name.human" do
            expect(config.resource_name).to receive(:translate).and_return "Da category"

            expect(config.resource_label).to eq "Da category"
          end
        end

        describe "plural label" do
          it "should return the titleized plural version defined by i18n if available" do
            expect(config.resource_name).to receive(:translate).at_least(:once).and_return "Da categories"
            expect(config.plural_resource_label).to eq "Da categories"
          end
        end

        describe "plural label with not default locale" do
          it "should return the titleized plural version defined by i18n with custom :count if available" do
            expect(config.resource_name).to receive(:translate).at_least(:once).and_return "Категории"
            expect(config.plural_resource_label(count: 3)).to eq "Категории"
          end
        end

        context "when the :as option is given" do
          describe "singular label" do
            it "should translate the custom name" do
              config = config(as: 'My Category')
              expect(config.resource_name).to receive(:translate).and_return "Translated category"
              expect(config.resource_label).to eq "Translated category"
            end
          end

          describe "plural label" do
            it "should translate the custom name" do
              config = config(as: 'My Category')
              expect(config.resource_name).to receive(:translate).at_least(:once).and_return "Translated categories"
              expect(config.plural_resource_label).to eq "Translated categories"
            end
          end
        end
      end
    end

    describe "duplicate resource names" do
      let(:resource_name) { config.resource_name }
      let(:duplicate_resource_name) { Resource.new(namespace, Category).resource_name }

      [:==, :===, :eql?].each do |method|
        it "are equivalent when compared with #{method}" do
          expect(resource_name.public_send(method, duplicate_resource_name)).to eq true
        end
      end

      it "have identical hash values" do
        expect(resource_name.hash).to eq duplicate_resource_name.hash
      end
    end
  end
end
