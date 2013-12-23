require 'spec_helper'

describe ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper do

  describe "class methods" do
    before :all do

      begin
        # The mime type to be used in respond_to |format| style web-services in rails
        Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
      rescue NameError
        puts "Mime module not defined. Skipping registration of xlsx"
      end

      class Foo
        include ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper
      end
    end

    it "extends the class to add a formats class method that returns the default formats." do
      expect(Foo.formats).to eq [:csv, :xml, :json]
    end

    it "does not let you alter the formats array directly" do
      Foo.formats << :xlsx
      expect(Foo.formats).to eq [:csv, :xml, :json]
    end

    it "allows us to add new formats" do
      Foo.add_format :xlsx
      expect(Foo.formats).to eq [:csv, :xml, :json, :xlsx]
    end

    it "raises an exception if you provide an unregisterd mime type extension" do
      expect{ Foo.add_format :hoge }.to raise_error
    end

  end
end
