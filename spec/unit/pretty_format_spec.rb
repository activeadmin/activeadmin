require 'rails_helper'

describe "#pretty_format" do
  class ViewContext
    include ActiveAdmin::ViewHelpers::DisplayHelper
  end

  let(:view_context) { ViewContext.new }
  let(:object) { double }
  let(:formatted_object) { "pretty formatted object" }

  it "calls 'ActiveAdmin::Formatter.format'" do
    expect(ActiveAdmin::Formatter).to receive(:format).with(object, view_context).and_return(formatted_object)
    expect(view_context.pretty_format(object)).to eq formatted_object
  end
end
