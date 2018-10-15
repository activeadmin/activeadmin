RSpec.describe ActiveAdmin::Views::Pages::Base do
  class NewPage < ActiveAdmin::Views::Pages::Base
  end

  it "defines a default title" do
    expect(NewPage.new.title).to eq 'NewPage'
  end

  it "defines default main content" do
    expect(NewPage.new.main_content).to eq 'Please implement NewPage#main_content to display content.'
  end
end
