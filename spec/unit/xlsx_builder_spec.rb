require 'spec_helper'
include ActiveAdmin
describe ActiveAdmin::XlsxBuilder do
  context "with shared strings" do
    let(:builder) do
      XlsxBuilder.new :shared_strings => true
    end

    it "should be set to use shared strings" do 
      builder.shared_strings.should be_true
    end
  end
  context "with i18n_scope" do
    let(:builder) do
      XlsxBuilder.new :i18n_scope => [:active_admin, :resource, :category]
    end

    it "should have the defined i18n_scope set" do
      builder.i18n_scope.should == [:active_admin, :resource, :category]
    end
  end

  context "with a customized header style" do
    let (:header_style) do
      { :bg_color => '00', :fg_color => 'FF', :sz => 14, :alignment => { :horizontal=> :center } }
    end

    let (:builder) do
      XlsxBuilder.new :header_style => header_style
    end

    it "should be set up with a header style" do
       header_style.each { |key , value| builder.header_style[key].should == value }
    end
  end
end

