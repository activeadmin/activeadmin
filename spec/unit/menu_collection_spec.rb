require 'spec_helper'

describe ActiveAdmin::MenuCollection do

  let(:menus) { ActiveAdmin::MenuCollection.new }

  describe "#add" do


    it "should initialize a new menu when first item" do
      menus.add :default, :label => "Hello World"

      menus.fetch(:default).items.size.should == 1
      menus.fetch(:default)["Hello World"].should be_an_instance_of(ActiveAdmin::MenuItem)
    end

    it "should add items to an existing menu" do
      menus.add :default, :label => "Hello World"
      menus.add :default, :label => "Hello World Again"

      menus.fetch(:default).items.size.should == 2
    end

  end

  describe "#clear!" do

    it "should remove all menus" do
      menus.add :default, :label => "Hello World"

      menus.clear!

      expect {
        menus.fetch(:non_default_menu)
      }.to raise_error(ActiveAdmin::MenuCollection::NoMenuError)

    end

  end

end
