require 'spec_helper'

describe ActiveAdmin::ViewHelpers::FormHelper do

  describe '.active_admin_form_for' do
    let(:view) { action_view }
    let(:resource) { stub('resource') }
    let(:default_options) { { builder: ActiveAdmin::FormBuilder } }

    it 'calls semantic_form_for with the ActiveAdmin form builder' do
      view.should_receive(:semantic_form_for).with(resource, builder: ActiveAdmin::FormBuilder)
      view.active_admin_form_for(resource)
    end

    it 'allows the form builder to be customized' do
      # We can't use a stub here because options gets marshalled, and a new
      # instance built. Any constant will work.
      custom_builder = Object
      view.should_receive(:semantic_form_for).with(resource, builder: custom_builder)
      view.active_admin_form_for(resource, builder: custom_builder)
    end

    context 'with a decorated resource' do
      let(:decorated) { stub('decorated_resource', model: resource) }

      it 'can disable automatic decoration' do
        view.should_receive(:semantic_form_for).with(resource, default_options.merge(decorate: false))
        view.active_admin_form_for(decorated, decorate: false)
      end

      it 'can enable automatic decoration' do
        view.should_receive(:semantic_form_for).with(decorated, default_options.merge(decorate: true))
        view.active_admin_form_for(decorated, decorate: true)
      end
    end
  end

  describe ".hidden_field_tags_for" do
    let(:view) { action_view }

    it "should render hidden field tags for params" do
      view.hidden_field_tags_for(:scope => "All", :filter => "None").should ==
        %{<input id="hidden_active_admin_scope" name="scope" type="hidden" value="All" />\n<input id="hidden_active_admin_filter" name="filter" type="hidden" value="None" />}
    end

    it "should generate not default id for hidden input" do
      view.hidden_field_tags_for(:scope => "All")[/id="([^"]+)"/, 1].should_not == "scope"
    end

    it "should filter out the field passed via the option :except" do
      view.hidden_field_tags_for({:scope => "All", :filter => "None"}, :except => :filter).should ==
        %{<input id="hidden_active_admin_scope" name="scope" type="hidden" value="All" />}
    end
  end
end

