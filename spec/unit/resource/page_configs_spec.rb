require 'spec_helper'

describe ActiveAdmin::Resource::PageConfigs do

  let(:namespace){ ActiveAdmin::Namespace.new(ActiveAdmin::Application.new, :admin) }
  let(:resource){ namespace.register(Post) }

  it "should have an empty set of configs on initialize" do
    resource.page_configs.should == {}
  end

  it "should add a page config" do
    page_config = ActiveAdmin::PageConfig.new
    resource.set_page_config(:index, page_config)
    resource.page_configs[:index].should == page_config
  end

  describe "#get_page_config" do

    it "should return a page config when set" do
      page_config = ActiveAdmin::PageConfig.new
      resource.set_page_config(:index, page_config)
      resource.get_page_config(:index).should == page_config
    end

    it "should return nil when no page config set" do
      resource.get_page_config(:index).should == nil
    end

  end

end
