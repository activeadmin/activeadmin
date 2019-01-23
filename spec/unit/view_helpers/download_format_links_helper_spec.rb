require 'rails_helper'

RSpec.describe ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper do
  describe "class methods" do
    before :all do
      # The mime type to be used in respond_to |format| style web-services in rails
      Mime::Type.register "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", :xlsx
    end

    subject do
      Class.new do
        include ActiveAdmin::ViewHelpers::DownloadFormatLinksHelper
      end
    end

    it "extends the class to add a formats class method that returns the default formats." do
      expect(subject.formats).to eq [:csv, :xml, :json]
    end

    it "does not let you alter the formats array directly" do
      subject.formats << :xlsx
      expect(subject.formats).to eq [:csv, :xml, :json]
    end

    it "allows us to add new formats" do
      subject.add_format :xlsx
      expect(subject.formats).to eq [:csv, :xml, :json, :xlsx]
    end

    it "raises an exception if you provide an unregisterd mime type extension" do
      expect { subject.add_format :hoge }.to raise_error 'Please register the hoge mime type with `Mime::Type.register`'
    end
  end
end
