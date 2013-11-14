require 'active_admin/view_helpers/fields_for'

describe ActiveAdmin::ViewHelpers::FormHelper, ".fields_for" do
  include ActiveAdmin::ViewHelpers::FormHelper

  it "should skip :action, :controller and :commit" do
    fields_for_params(
      :scope => "All", :action => "index", :controller => "PostController", :commit => "Filter", :utf8 => "Yes!").
      should eq [ { :scope => "All" } ]
  end

  it "should skip the except" do
    fields_for_params({:scope => "All", :name => "Greg"}, :except => :name).
      should eq [ { :scope => "All" } ]
  end

  it "should allow an array for the except" do
    fields_for_params({:scope => "All", :name => "Greg", :age => "12"}, :except => [:name, :age]).
      should eq [ { :scope => "All" } ]
  end

  it "should work with hashes" do
    params = fields_for_params(:filters => { :name => "John", :age => "12" })

    expect(params.size).to eq 2
    expect(params).to include({"filters[name]" => "John" })
    expect(params).to include({ "filters[age]" => "12" })
  end

  it "should work with nested hashes" do
    fields_for_params(:filters => { :user => { :name => "John" }}).
      should eq [ { "filters[user][name]" => "John" } ]
  end

  it "should work with arrays" do
    fields_for_params(:people => ["greg", "emily", "philippe"]).
      should eq [ { "people[]" => "greg" },
                  { "people[]" => "emily" },
                  { "people[]" => "philippe" } ]
  end

  it "should work with symbols" do
    fields_for_params(:filter => :id).
      should eq [ { :filter => "id" } ]
  end

  it "should work with booleans" do
    expect(fields_for_params(:booleantest => false)).to eq [ { :booleantest => false } ]
  end
end
