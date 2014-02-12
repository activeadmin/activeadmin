require 'spec_helper'

describe ActiveAdmin::ViewHelpers::FormHelper do

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

    context 'with a decorated resource' do
      let(:decorated) { double 'decorated_resource', model: resource }

      it 'can disable automatic decoration' do
        expect(view).to receive(:semantic_form_for).with(resource, default_options.merge(decorate: false))
        view.active_admin_form_for(decorated, decorate: false)
      end

      it 'can enable automatic decoration' do
        expect(view).to receive(:semantic_form_for).with(decorated, default_options.merge(decorate: true))
        view.active_admin_form_for(decorated, decorate: true)
      end

      it 'defaults to not decorating' do
        expect(view).to receive(:semantic_form_for).with(resource, default_options)
        view.active_admin_form_for(decorated)
      end
    end
  end

  describe ".hidden_field_tags_for" do
    let(:view) { action_view }

    it "should render hidden field tags for params" do
      expect(view.hidden_field_tags_for(:scope => "All", :filter => "None")).to eq \
        %{<input id="hidden_active_admin_scope" name="scope" type="hidden" value="All" />\n<input id="hidden_active_admin_filter" name="filter" type="hidden" value="None" />}
    end

    it "should generate not default id for hidden input" do
      expect(view.hidden_field_tags_for(:scope => "All")[/id="([^"]+)"/, 1]).to_not eq "scope"
    end

    it "should filter out the field passed via the option :except" do
      expect(view.hidden_field_tags_for({:scope => "All", :filter => "None"}, :except => :filter)).to eq \
        %{<input id="hidden_active_admin_scope" name="scope" type="hidden" value="All" />}
    end
  end
end

