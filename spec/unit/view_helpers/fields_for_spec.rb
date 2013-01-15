require 'active_admin/view_helpers/fields_for'

describe ActiveAdmin::ViewHelpers::FormHelper, ".fields_for" do
  include ActiveAdmin::ViewHelpers::FormHelper

  it "should skip :action, :controller and :commit" do
    fields_for_params(
      :scope => "All", :action => "index", :controller => "PostController", :commit => "Filter", :utf8 => "Yes!").
      should == [ { :scope => "All" } ]
  end

  it "should skip the except" do
    fields_for_params({:scope => "All", :name => "Greg"}, :except => :name).
      should == [ { :scope => "All" } ]
  end

  it "should allow an array for the except" do
    fields_for_params({:scope => "All", :name => "Greg", :age => "12"}, :except => [:name, :age]).
      should == [ { :scope => "All" } ]
  end

  it "should work with hashes" do
    params = fields_for_params(:filters => { :name => "John", :age => "12" })

    params.size.should == 2
    params.should include({"filters[name]" => "John" })
    params.should include({ "filters[age]" => "12" })
  end

  it "should work with nested hashes" do
    fields_for_params(:filters => { :user => { :name => "John" }}).
      should == [ { "filters[user][name]" => "John" } ]
  end

  it "should work with arrays" do
    fields_for_params(:people => ["greg", "emily", "philippe"]).
      should == [ { "people[]" => "greg" },
                  { "people[]" => "emily" },
                  { "people[]" => "philippe" } ]
  end

  it "should work with symbols" do
    fields_for_params(:filter => :id).
      should == [ { :filter => "id" } ]
  end

  it "should work with booleans" do
    fields_for_params(:booleantest => false).should == [ { :booleantest => false } ]
  end
end
