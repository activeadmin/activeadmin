# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Pages::Base do
  let(:base_class) { Class.new(described_class) }

  around do |example|
    NewPage = base_class
    example.run
    Object.send(:remove_const, :NewPage)
  end

  it "defines a default title" do
    expect(base_class.new.title).to eq "NewPage"
  end

  it "defines default main content" do
    expect(base_class.new.main_content).to eq "Please implement NewPage#main_content to display content."
  end
end
