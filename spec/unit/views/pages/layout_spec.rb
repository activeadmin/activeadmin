# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Pages::Layout do
  let(:assigns) { {} }
  let(:helpers) { mock_action_view }
  let(:arbre_context) { Arbre::Context.new(assigns, helpers) }
  let(:layout) { described_class.new(arbre_context) }

  it "should be the @page_title if assigned in the controller" do
    assigns[:page_title] = "My Page Title"

    expect(layout.title).to eq "My Page Title"
  end

  it "should be the default translation" do
    helpers.params[:action] = "edit"

    expect(layout.title).to eq "Edit"
  end
end
