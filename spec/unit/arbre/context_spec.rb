# coding: utf-8
require 'spec_helper'

describe Arbre::Context do

  setup_arbre_context!

  before do
    h1 "札幌市北区" # Add some HTML to the context
  end

  it "should not increment the indent_level" do
    current_dom_context.indent_level.should == -1
  end

  it "should return a bytesize" do
    current_dom_context.bytesize.should == 25
  end

  it "should return a length" do
    current_dom_context.length.should == 25
  end

  it "should delegate missing methods to the html string" do
    current_dom_context.should respond_to(:index)
    current_dom_context.index('<').should == 0
  end

  it "should use a cached version of the HTML for method delegation" do
    current_dom_context.should_receive(:to_s).once.and_return("<h1>札幌市北区</h1>")
    current_dom_context.index('<').should == 0
    current_dom_context.index('<').should == 0
  end

end
