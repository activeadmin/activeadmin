require 'rails_helper'

RSpec.shared_examples_for "ActiveAdmin::Localizers::ResourceLocalizer" do
  it "should use proper translation" do
    string = ActiveAdmin::Localizers::ResourceLocalizer.t(action, model: model, model_name: model_name)
    expect(string).to eq translation
  end

  it "should accessible via ActiveAdmin::Localizers" do
    resource = double(resource_label: model, resource_name: double(i18n_key: model_name))
    localizer = ActiveAdmin::Localizers.resource(resource)
    expect(localizer.t(action)).to eq translation
  end
end

RSpec.describe ActiveAdmin::Localizers::ResourceLocalizer do
  let(:action) { 'new_model' }
  let(:model) { 'Comment' }
  let(:model_name) { 'comment' }

  it_behaves_like "ActiveAdmin::Localizers::ResourceLocalizer" do
    let(:translation) { 'New Comment' }
  end

  describe "model action specified" do
    around do |example|
      with_translation active_admin: {resources: {comment: {new_model: 'Write comment'}}} do
        example.call
      end
    end

    it_behaves_like "ActiveAdmin::Localizers::ResourceLocalizer" do
      let(:translation) { 'Write comment' }
    end
  end
end
