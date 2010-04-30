require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdmin

describe ActiveAdmin::TableBuilder do
  
  it "should use the active_admin_table display method" do
    TableBuilder.new.display_method.should == :active_admin_table
  end
  
  describe "when creating a simple column" do
    before(:each) do
      @builder = TableBuilder.new do |t|
        t.column :first_name
      end
    end
    
    it "should set the column title" do
      @builder.columns.first.title.should == 'First Name'
    end
    
    it "should set the column data" do
      @builder.columns.first.data.should == :first_name
    end
  end
  
  it "should generate multiple columns" do
    builder = TableBuilder.new do |t|
      t.column :username
      t.column :last_name
    end
    builder.columns.size.should == 2
  end
  
  describe 'when creating a column with a title' do
    before(:each) do
      @builder = TableBuilder.new do |t|
        t.column 'My Great Username', :username
      end
    end
    
    it "should set the column title" do
      @builder.columns.first.title.should == 'My Great Username'
    end
    
    it "should set the column data" do
      @builder.columns.first.data.should == :username
    end
  end
  
  describe 'when creating a column with a title and a block as the data' do
    before(:each) do
      @builder = TableBuilder.new do |t|
        t.column('Username'){ |u| u.username }
      end
    end
    
    it "should set the column title" do
      @builder.columns.first.title.should == 'Username'
    end
    
    it "should set the column data" do
      @builder.columns.first.data.should be_a(Proc)
    end
  end

  it "should generate many columns" do
    builder = TableBuilder.new do |t|
      t.columns :first, :second, :third
    end
    builder.columns.size.should == 3
    builder.columns.first.data.should == :first
  end
    
end
