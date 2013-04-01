require 'spec_helper'

# Ensure we have both constants to play with
begin
  ActionDispatch::Reloader
rescue
  module ActionDispatch; module Reloader; def self.to_prepare; end; end; end
end

begin
  ActionDispatch::Callbacks
rescue
  module ActionDispatch; module Callbacks; def self.to_prepare; end; end; end
end

major_rails_version = Rails.version[0..2]


describe ActiveAdmin::Reloader do

  let(:rails_app){ mock(:reload_routes! => true)}
  let(:mock_app){ mock(:load_paths => ["app/admin"], :unload! => true)}
  let(:reloader){ ActiveAdmin::Reloader.build(rails_app, mock_app, rails_version) }

  context "when Rails version < 3.2" do
    let(:rails_version){ TRAVIS_RAILS_VERSIONS.grep(/^3.1/).first }

    describe "initialization" do

      it "should initialize a new file update checker" do
        ActiveSupport::FileUpdateChecker.should_receive(:new).with(mock_app.load_paths).and_return(mock(:execute_if_updated => true))
        ActiveAdmin::Reloader.build(rails_app, mock_app, TRAVIS_RAILS_VERSIONS.grep(/^3.1/).first)
      end

      it "should build a RailsLessThan31Reloader" do
        reloader.class.should == ActiveAdmin::Reloader::RailsLessThan31Reloader
      end

    end

    describe "#reloader_class" do

      it "should use ActionDispatch::Reloader if rails 3.1" do
        reloader = ActiveAdmin::Reloader.build rails_app, mock_app, TRAVIS_RAILS_VERSIONS.grep(/^3.1/).first
        reloader.reloader_class.should == ActionDispatch::Reloader
      end

      it "should use ActionDispatch::Callbacks if rails 3.0" do
        reloader = ActiveAdmin::Reloader.build rails_app, mock_app, TRAVIS_RAILS_VERSIONS.grep(/^3.0/).first
        reloader.reloader_class.should == ActionDispatch::Callbacks
      end

    end

    describe "#reload!" do

      it "should unload the active admin app" do
        mock_app.should_receive(:unload!)
        reloader.reload!
      end

      it "should reload the rails app routes" do
        rails_app.should_receive(:reload_routes!)
        reloader.reload!
      end

      it 'should reset the files within the file_update_checker' do
        reloader.file_update_checker.paths.should_receive(:clear)
        reloader.file_update_checker.paths.should_receive(:<<).with("app/admin")
        reloader.reload!
      end

    end

    describe "#watched_paths" do
      let(:mock_app){ ActiveAdmin::Application.new }
      let(:admin_path){ File.join(Rails.root, "app", "admin") }

      before do
        mock_app.load_paths = [admin_path]
      end

      it "should return the load path directories" do
        reloader.watched_paths.should include(admin_path)
      end

      it "should include all files in the directory" do
        root = Rails.root + "/app/admin"
        reloader.watched_paths.should include(*Dir["#{admin_path}/**/*.rb"])
      end

    end

  end

  context "when Rails >= 3.2" do
    let(:rails_version){ TRAVIS_RAILS_VERSIONS.grep(/^3.2/).first }

    describe "initialization" do

      it "should build a Rails32Reloader" do
        reloader.class.should == ActiveAdmin::Reloader::Rails32Reloader
      end

    end

    describe "attach!" do
      before do
        mock_app.load_paths << "app/active_admin"
        ActionDispatch::Reloader.stub!(:to_prepare => true)
      end

      it "should the load paths to the watchable_dirs" do
        config = mock(:watchable_dirs => {})
        rails_app.should_receive(:config).twice.and_return(config)
        reloader.attach!

        config.watchable_dirs["app/admin"].should == [:rb]
        config.watchable_dirs["app/active_admin"].should == [:rb]
      end
    end
  end

end
