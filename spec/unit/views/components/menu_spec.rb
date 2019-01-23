require 'rails_helper'

RSpec.describe ActiveAdmin::Views::Menu do
  let(:menu) { ActiveAdmin::Menu.new }

  let(:assigns) { { active_admin_menu: menu } }
  let(:helpers) { mock_action_view }

  let(:menu_component) do
    arbre(assigns, helpers) {
      insert_tag(ActiveAdmin::Views::Menu, active_admin_menu)
    }.children.first
  end

  let(:html) { Capybara.string(menu_component.to_s) }

  before do
    load_resources { ActiveAdmin.register Post }
    allow(helpers).to receive(:admin_logged_in?).and_return(false)
  end

  describe "rendering a menu" do
    before do
      menu.add label: "Blog Posts", url: :admin_posts_path

      menu.add label: "Reports", url: "/admin/reports" do |reports|
        reports.add label: "A Sub Reports", url: "/admin/a-sub-reports"
        reports.add label: "B Sub Reports", url: "/admin/b-sub-reports"
        reports.add label: proc { "Label Proc Sub Reports" }, url: "/admin/label-proc-sub-reports", id: "Label Proc Sub Reports"
      end

      menu.add label: "Administration", url: "/admin/administration" do |administration|
        administration.add label: "User administration",
                           url: '/admin/user-administration',
                           priority: 10,
                           if: proc { false }
      end

      menu.add label: "Management", url: "#" do |management|
        management.add label: "Order management",
                       url: '/admin/order-management',
                       priority: 10,
                       if: proc { false }
        management.add label: "Bill management",
                       url: '/admin/bill-management',
                       priority: 10,
                       if: :admin_logged_in?
      end

      menu.add label: "Charles Smith", id: "current_user", url: -> { nil }
    end

    it "should generate a ul" do
      expect(html).to have_selector("ul")
    end

    it "should generate an li for each item" do
      expect(html).to have_selector("ul > li")
    end

    it "should generate a link for each item" do
      expect(html).to have_selector("a[href='/admin/posts']", text: "Blog Posts")
    end

    it "should generate a nested list for children" do
      expect(html).to have_selector("li > ul")
    end

    it "should generate a nested list with li for each child" do
      expect(html).to have_selector("ul > li#a_sub_reports")
      expect(html).to have_selector("ul > li#b_sub_reports")
    end

    it "should generate a valid id from a label proc" do
      expect(html).to have_selector("ul > li#label_proc_sub_reports")
    end

    it "should not generate a link for user administration" do
      expect(html).to_not have_selector("a[href='/admin/user-administration']", text: "User administration")
    end

    it "should generate the administration parent menu" do
      expect(html).to have_selector("a[href='/admin/administration']", text: "Administration")
    end

    it "should not generate a link for order management" do
      expect(html).to_not have_selector("a[href='/admin/order-management']", text: "Order management")
    end

    it "should not generate a link for bill management" do
      expect(html).to_not have_selector("a[href='/admin/bill-management']", text: "Bill management")
    end

    it "should not generate the management parent menu" do
      expect(html).to_not have_selector("a[href='#']", text: "Management")
    end

    context "when url is nil" do
      it "should generate a span" do
        selector = "li#current_user > span"
        expect(html).to have_selector(selector, text: "Charles Smith")
      end
    end

    describe "marking current item" do
      it "should add the 'current' class to the li" do
        assigns[:current_tab] = menu["Blog Posts"]
        expect(html).to have_selector("li.current")
      end

      it "should add the 'current' and 'has_nested' classes to the li and 'current' to the sub li" do
        assigns[:current_tab] = menu["Reports"]["A Sub Reports"]
        expect(html).to have_selector("li#reports.current")
        expect(html).to have_selector("li#reports.has_nested")
        expect(html).to have_selector("li#a_sub_reports.current")
      end
    end
  end

  describe "returning the menu items to display" do
    it "should return one item with no if block" do
      menu.add label: "Hello World", url: "/"
      expect(menu_component.children.map(&:id)).to eq %w(hello_world)
    end

    it "should not include menu items with an if block that returns false" do
      menu.add label: "Don't Show", url: "/", priority: 10, if: proc { false }
      expect(menu_component.children).to be_empty
    end

    it "should not include menu items with an if block that calls a method that returns false" do
      menu.add label: "Don't Show", url: "/", priority: 10, if: :admin_logged_in?
      expect(menu_component.children).to be_empty
    end

    it "should not display any items that have no children to display" do
      menu.add label: "Parent", url: "#" do |p|
        p.add label: "Child", url: "/", priority: 10, if: proc { false }
      end
      expect(html.all('li')).to be_empty
    end

    it "should display a parent that has a child to display" do
      menu.add label: "Parent", url: "#" do |p|
        p.add label: "Hidden Child", url: "/", priority: 10, if: proc { false }
        p.add label: "Child", url: "/"
      end
      expect(menu_component.children.size).to eq(1)
    end
  end

  describe "sorting items" do
    it "should sort children by the result of their label proc" do
      menu.add label: proc { "G" }, id: "not related 1"
      menu.add label: proc { "B" }, id: "not related 2"
      menu.add label: proc { "A" }, id: "not related 3"

      expect(menu_component.children.map(&:label)).to eq %w[A B G]
    end
  end
end
