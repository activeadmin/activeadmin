require 'rails_helper'

RSpec.describe ActiveAdmin::Namespace do
  let(:application) { ActiveAdmin::Application.new }

  context "when new" do
    let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }

    it "should have an application instance" do
      expect(namespace.application).to eq application
    end

    it "should have a name" do
      expect(namespace.name).to eq :admin
    end

    it "should have no resources" do
      expect(namespace.resources).to be_empty
    end

    it "should not have any menu item" do
      expect(namespace.fetch_menu(:default).children).to be_empty
    end
  end # context "when new"

  describe "#unload!" do
    context "when controller is only defined without a namespace" do
      before do
        # To ensure Admin::PostsController is defined
        ActiveAdmin.register Post

        # To ensure ::PostsController is defined
        ActiveAdmin.register Post, namespace: false

        # To prevent unload! from unregistering ::PostsController
        ActiveAdmin.application.namespaces.instance_variable_get(:@namespaces).delete(:root)

        # To force Admin::PostsController to not be there
        Admin.send(:remove_const, 'PostsController')
      end

      after do
        load_resources {}
      end

      it "should not crash" do
        expect { ActiveAdmin.unload! }.not_to raise_error
      end
    end
  end

  describe "settings" do
    let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }

    it "should inherit the site title from the application" do
      ActiveSupport::Deprecation.silence do
        ActiveAdmin::Namespace.setting :site_title, "Not the Same"
      end
      expect(namespace.site_title).to eq application.site_title
    end

    it "should be able to override the site title" do
      expect(namespace.site_title).to eq application.site_title
      namespace.site_title = "My Site Title"
      expect(namespace.site_title).to_not eq application.site_title
    end
  end

  describe "#fetch_menu" do
    let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }

    it "returns the menu" do
      expect(namespace.fetch_menu(:default)).to be_an_instance_of(ActiveAdmin::Menu)
    end

    it "should have utility nav menu" do
      expect(namespace.fetch_menu(:utility_navigation)).to be_an_instance_of(ActiveAdmin::Menu)
    end

    it "should raise an exception if the menu doesn't exist" do
      expect {
        namespace.fetch_menu(:not_a_menu_that_exists)
      }.to raise_error(KeyError)
    end
  end

  describe "#build_menu" do
    let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }

    it "should set the block as a menu build callback" do
      namespace.build_menu do |menu|
        menu.add label: "menu item"
      end

      expect(namespace.fetch_menu(:default)["menu item"]).to_not eq nil
    end

    it "should set a block on a custom menu" do
      namespace.build_menu :test do |menu|
        menu.add label: "menu item"
      end

      expect(namespace.fetch_menu(:test)["menu item"]).to_not eq nil
    end
  end

  describe "utility navigation" do
    let(:namespace) { ActiveAdmin::Namespace.new(application, :admin) }
    let(:menu) do
      namespace.build_menu :utility_navigation do |menu|
        menu.add label: "ActiveAdmin.info", url: "http://www.activeadmin.info", html_options: { target: :blank }
        namespace.add_logout_button_to_menu menu, 1, class: "matt"
      end
      namespace.fetch_menu(:utility_navigation)
    end

    it "should have a logout button to the far left" do
      expect(menu["Logout"]).to_not eq nil
      expect(menu["Logout"].priority).to eq 1
    end

    it "should have a static link with a target of :blank" do
      expect(menu["ActiveAdmin.info"]).to_not eq nil
      expect(menu["ActiveAdmin.info"].html_options).to include(target: :blank)
    end
  end
end
