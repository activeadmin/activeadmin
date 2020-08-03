require 'rails_helper'

RSpec.describe "AA installation" do
  context "should create" do
    let(:asset_pipeline_stylesheet_dir) { Rails.root + 'app/assets/stylesheets' }
    let(:asset_pipeline_javascript_dir) { Rails.root + 'app/assets/javascripts' }

    let(:webpacker_stylesheet_dir) { Rails.root + 'app/javascript/stylesheets' }
    let(:webpacker_javascript_dir) { Rails.root + 'app/javascript/packs' }

    let(:stylesheet_dir) { ActiveAdmin.application.use_webpacker ? webpacker_stylesheet_dir : asset_pipeline_stylesheet_dir }
    let(:javascript_dir) { ActiveAdmin.application.use_webpacker ? webpacker_javascript_dir : asset_pipeline_javascript_dir }

    it 'active_admin.scss' do
      path = stylesheet_dir + 'active_admin.scss'

      expect(File.exist?(path)).to eq true
    end

    if ActiveAdmin.application.use_webpacker
      it 'active_admin/print.scss' do
        path = stylesheet_dir + 'active_admin/print.scss'

        expect(File.exist?(path)).to eq true
      end
    end

    it 'active_admin.js' do
      path = javascript_dir + 'active_admin.js'

      expect(File.exist?(path)).to eq true
    end

    it "the dashboard" do
      path = Rails.root + "app/admin/dashboard.rb"

      expect(File.exist?(path)).to eq true
    end

    it "the initializer" do
      path = Rails.root + "config/initializers/active_admin.rb"

      expect(File.exist?(path)).to eq true
    end
  end
end
