require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ActiveAdmin

describe ActiveAdmin::FormBuilder do
  
  before(:each) do
    @form = FormBuilder.new do |f|
      f.inputs "User Details" do
        f.input :username
        f.input :first_name
        f.input :last_name
      end
      f.inputs "Password" do
        f.input :password
        f.input :password_confirmation
      end
      f.inputs "Account Info", :for => :account do |account_form|
        account_form.input :subdomain
      end
      f.buttons
    end
  end

  it "should track level method calls" do
    @form.calls.size.should == 4
  end
  
  it "should store the arguments" do
    @form.calls.first.args.should == ["User Details"]
  end
  
  it "should store the method calls in the inputs block" do
    user_details = @form.calls.first
    user_details.children.size.should == 3
  end
  
  it "should store the method name of children methods" do
    user_details = @form.calls.first
    user_details.children.first.name.should == :input
  end
  
  it "should store the arguments of the children methods" do
    user_details = @form.calls.first
    user_details.children.first.args.should == [:username]
  end
  
  it "should store method calls to blocks which accept a parameter" do
    account_info = @form.calls[2]
    account_info.children.first.name.should == :input
  end
  
end