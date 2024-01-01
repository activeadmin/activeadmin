# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::FormHelper, type: :helper do
  describe ".active_admin_form_for" do
    let(:resource) { double "resource" }

    it "calls semantic_form_for with the ActiveAdmin form builder" do
      expect(helper).to receive(:semantic_form_for).with(resource, { builder: ActiveAdmin::FormBuilder })
      helper.active_admin_form_for(resource)
    end

    it "allows the form builder to be customized" do
      # We can't use a stub here because options gets marshalled, and a new
      # instance built. Any constant will work.
      custom_builder = Object
      expect(helper).to receive(:semantic_form_for).with(resource, { builder: custom_builder })
      helper.active_admin_form_for(resource, builder: custom_builder)
    end
  end

  describe ".hidden_field_tags_for" do
    it "should render hidden field tags for params" do
      params = ActionController::Parameters.new(scope: "All", filter: "None")
      html = Capybara.string helper.hidden_field_tags_for(params)
      expect(html).to have_field("scope", id: "hidden_active_admin_scope", type: :hidden, with: "All")
      expect(html).to have_field("filter", id: "hidden_active_admin_filter", type: :hidden, with: "None")
    end

    it "should generate not default id for hidden input" do
      params = ActionController::Parameters.new(scope: "All")
      expect(helper.hidden_field_tags_for(params)[/id="([^"]+)"/, 1]).to_not eq "scope"
    end

    it "should filter out the field passed via the option :except" do
      params = ActionController::Parameters.new(scope: "All", filter: "None")
      html = Capybara.string helper.hidden_field_tags_for(params, except: :filter)
      expect(html).to have_field("scope", id: "hidden_active_admin_scope", type: :hidden, with: "All")
    end
  end

  describe ".fields_for_params" do
    it "should skip :action, :controller and :commit" do
      expect(helper.fields_for_params(scope: "All", action: "index", controller: "PostController", commit: "Filter", utf8: "Yes!")).to eq [ { scope: "All" } ]
    end

    it "should skip the except" do
      expect(helper.fields_for_params({ scope: "All", name: "Greg" }, except: :name)).to eq [ { scope: "All" } ]
    end

    it "should allow an array for the except" do
      expect(helper.fields_for_params({ scope: "All", name: "Greg", age: "12" }, except: [:name, :age])).to eq [ { scope: "All" } ]
    end

    it "should work with hashes" do
      params = helper.fields_for_params(filters: { name: "John", age: "12" })

      expect(params.size).to eq 2
      expect(params).to include({ "filters[name]" => "John" })
      expect(params).to include({ "filters[age]" => "12" })
    end

    it "should work with nested hashes" do
      expect(helper.fields_for_params(filters: { user: { name: "John" } })).to eq [ { "filters[user][name]" => "John" } ]
    end

    it "should work with arrays" do
      expect(helper.fields_for_params(people: ["greg", "emily", "philippe"])).
        to eq [ { "people[]" => "greg" },
                { "people[]" => "emily" },
                { "people[]" => "philippe" } ]
    end

    it "should work with symbols" do
      expect(helper.fields_for_params(filter: :id)).to eq [ { filter: "id" } ]
    end

    it "should work with booleans" do
      expect(helper.fields_for_params(booleantest: false)).to eq [ { booleantest: false } ]
    end

    it "should work with nil" do
      expect(helper.fields_for_params(a: nil)).to eq [ { a: "" } ]
    end

    it "should raise an error with an unsupported type" do
      expect { helper.fields_for_params(a: 1) }.to raise_error(TypeError, "Cannot convert Integer value: 1")
    end
  end
end
