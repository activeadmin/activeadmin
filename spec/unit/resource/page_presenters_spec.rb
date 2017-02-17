require 'rails_helper'

RSpec.describe ActiveAdmin::Resource::PagePresenters do

  let(:namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin) }
  let(:resource){ namespace.register(Post) }

  it "should have an empty set of configs on initialize" do
    expect(resource.page_presenters).to eq ({})
  end

  it "should add a show page presenter" do
    page_presenter = ActiveAdmin::PagePresenter.new
    resource.set_page_presenter(:show, page_presenter)
    expect(resource.page_presenters[:show]).to eq page_presenter
  end

  it "should add an index page presenter" do
    page_presenter = ActiveAdmin::PagePresenter.new({as: :table})
    resource.set_page_presenter(:index, page_presenter)
    expect(resource.page_presenters[:index].default).to eq page_presenter
  end

  describe "#get_page_presenter" do

    it "should return a page config when set" do
      page_presenter = ActiveAdmin::PagePresenter.new
      resource.set_page_presenter(:index, page_presenter)
      expect(resource.get_page_presenter(:index)).to eq page_presenter
    end

    it "should return a specific index page config when set" do
      page_presenter = ActiveAdmin::PagePresenter.new
      resource.set_page_presenter(:index, page_presenter)
      expect(resource.get_page_presenter(:index, "table")).to eq page_presenter
    end

    it "should return nil when no page config set" do
      expect(resource.get_page_presenter(:index)).to eq nil
    end

  end

end
