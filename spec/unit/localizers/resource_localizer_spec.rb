require 'rails_helper'
require File.expand_path('../config_shared_examples', File.dirname(__FILE__))

RSpec.describe ActiveAdmin::Localizers::ResourceLocalizer do
  let(:action) { 'new_model' }
  let(:model) { 'Comment' }
  let(:model_name) { 'comment' }

  it_behaves_like "ActiveAdmin::Localizers::ResourceLocalizer" do
    let(:translation) { 'New Comment' }
  end

  describe "model action specified" do
    before do
      I18n.backend.store_translations :en, active_admin: {resources: {comment: {new_model: 'Write comment'}}}
    end

    it_behaves_like "ActiveAdmin::Localizers::ResourceLocalizer" do
      let(:translation) { 'Write comment' }
    end
  end
end
