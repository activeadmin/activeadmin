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

  describe "#on_build" do

    it "runs a callback when fetching a menu" do
      menus.on_build do |m|
        m.add :default, :label => "Hello World"
      end

      menus.fetch(:default)["Hello World"].should_not be_nil
    end

    it "re-runs the callbacks when the menu is cleared" do
      menus.on_build do |m|
        m.add :default, :label => "Hello World"
      end

      menus.fetch(:default)["Hello World"].should_not be_nil
      menus.clear!
      menus.fetch(:default)["Hello World"].should_not be_nil
    end

  end

end
