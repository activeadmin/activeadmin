require 'rails_helper'

RSpec.describe ActiveAdmin::ViewHelpers::FormHelper do

  describe '.active_admin_form_for' do
    let(:view) { action_view }
    let(:resource) { double 'resource' }
    let(:default_options) { { builder: ActiveAdmin::FormBuilder } }

    it 'calls semantic_form_for with the ActiveAdmin form builder' do
      expect(view).to receive(:semantic_form_for).with(resource, builder: ActiveAdmin::FormBuilder)
      view.active_admin_form_for(resource)
    end

    it 'allows the form builder to be customized' do
      # We can't use a stub here because options gets marshalled, and a new
      # instance built. Any constant will work.
      custom_builder = Object
      expect(view).to receive(:semantic_form_for).with(resource, builder: custom_builder)
      view.active_admin_form_for(resource, builder: custom_builder)
    end
  end

  describe ".hidden_field_tags_for" do
    let(:view) { action_view }

    it "should render hidden field tags for params" do
      html = Capybara.string view.hidden_field_tags_for(ActionController::Parameters.new(scope: "All", filter: "None"))
      expect(html).to have_selector("input#hidden_active_admin_scope[name=scope][type=hidden][value=All]", visible: false)
      expect(html).to have_selector("input#hidden_active_admin_filter[name=filter][type=hidden][value=None]", visible: false)
    end

    it "should generate not default id for hidden input" do
      expect(view.hidden_field_tags_for(ActionController::Parameters.new(scope: "All"))[/id="([^"]+)"/, 1]).to_not eq "scope"
    end

    it "should filter out the field passed via the option :except" do
      html = Capybara.string view.hidden_field_tags_for(ActionController::Parameters.new(scope: "All", filter: "None"), except: :filter)
      expect(html).to have_selector("input#hidden_active_admin_scope[name=scope][type=hidden][value=All]", visible: false)
    end
  end
end
