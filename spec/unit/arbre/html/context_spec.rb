require 'spec_helper'

describe Arbre::Context do
  include Arbre::HTML
  let(:assigns){ {} }

  before do
    h1 # Add some HTML to the context
  end

  it "should return a bytesize" do
    current_dom_context.bytesize.should == 10
  end

  it "should return a length" do
    current_dom_context.length.should == 10
  end

  it "should not increment the indent_level" do
    current_dom_context.indent_level.should == -1
  end
end
