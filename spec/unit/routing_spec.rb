require 'rails_helper'

RSpec.describe "Routing", type: :routing do
  let(:namespaces) { ActiveAdmin.application.namespaces }

  it "should only have the namespaces necessary for route testing" do
    expect(namespaces.names).to eq [:admin]
  end

  describe "admin dashboard" do
    around do |example|
      with_resources_during(example) {}
    end

    it "should route to the admin dashboard" do
      expect(get('/admin')).to route_to 'admin/dashboard#index'
    end
  end

  describe "root path helper" do
    around do |example|
      with_resources_during(example) {}
    end

    context "when in admin namespace" do
      it "should be admin_root_path" do
        expect(admin_root_path).to eq "/admin"
      end
    end
  end

  describe "route_options" do
    around do |example|
      with_resources_during(example) { ActiveAdmin.register(Post) }
    end

    context "with a custom path set in route_options" do
      before do
        namespaces[:admin].route_options = { path: '/custom-path' }
        reload_routes!
      end

      after do
        namespaces[:admin].route_options = {}
        reload_routes!
      end

      it "should route using the custom path" do
        expect(admin_posts_path).to eq "/custom-path/posts"
      end
    end
  end

  describe "standard resources" do
    around do |example|
      with_resources_during(example) { ActiveAdmin.register(Post) }
    end

    context "when in admin namespace" do
      it "should route the index path" do
        expect(admin_posts_path).to eq "/admin/posts"
      end

      it "should route the show path" do
        expect(admin_post_path(1)).to eq "/admin/posts/1"
      end

      it "should route the new path" do
        expect(new_admin_post_path).to eq "/admin/posts/new"
      end

      it "should route the edit path" do
        expect(edit_admin_post_path(1)).to eq "/admin/posts/1/edit"
      end
    end

    context "when in root namespace" do
      around do |example|
        with_resources_during(example) { ActiveAdmin.register(Post, namespace: false) }
      end

      after do
        namespaces.instance_variable_get(:@namespaces).delete(:root)
      end

      it "should route the index path" do
        expect(posts_path).to eq "/posts"
      end

      it "should route the show path" do
        expect(post_path(1)).to eq "/posts/1"
      end

      it "should route the new path" do
        expect(new_post_path).to eq "/posts/new"
      end

      it "should route the edit path" do
        expect(edit_post_path(1)).to eq "/posts/1/edit"
      end
    end

    context "with member action" do
      context "without an http verb" do
        around do |example|
          with_resources_during(example) do
            ActiveAdmin.register(Post) { member_action "do_something" }
          end
        end

        it "should default to GET" do
          expect({ get: "/admin/posts/1/do_something" }).to      be_routable
          expect({ post: "/admin/posts/1/do_something" }).to_not be_routable
        end
      end

      context "with one http verb" do
        around do |example|
          with_resources_during(example) do
            ActiveAdmin.register(Post) { member_action "do_something", method: :post }
          end
        end

        it "should properly route" do
          expect({ post: "/admin/posts/1/do_something" }).to be_routable
        end
      end

      context "with two http verbs" do
        around do |example|
          with_resources_during(example) do
            ActiveAdmin.register(Post) { member_action "do_something", method: [:put, :delete] }
          end
        end

        it "should properly route the first verb" do
          expect({ put: "/admin/posts/1/do_something" }).to be_routable
        end

        it "should properly route the second verb" do
          expect({ delete: "/admin/posts/1/do_something" }).to be_routable
        end
      end
    end
  end

  describe "belongs to resource" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(User)
        ActiveAdmin.register(Post) { belongs_to :user, optional: true }
      end
    end

    it "should route the nested index path" do
      expect(admin_user_posts_path(1)).to eq "/admin/users/1/posts"
    end

    it "should route the nested show path" do
      expect(admin_user_post_path(1, 2)).to eq "/admin/users/1/posts/2"
    end

    it "should route the nested new path" do
      expect(new_admin_user_post_path(1)).to eq "/admin/users/1/posts/new"
    end

    it "should route the nested edit path" do
      expect(edit_admin_user_post_path(1, 2)).to eq "/admin/users/1/posts/2/edit"
    end

    context "with collection action" do
      around do |example|
        with_resources_during(example) do
          ActiveAdmin.register(Post) do
            belongs_to :user, optional: true
          end
          ActiveAdmin.register(User) do
            collection_action "do_something"
          end
        end
      end

      it "should properly route the collection action" do
        expect({ get: "/admin/users/do_something" }).to \
          route_to({ controller: 'admin/users', action: 'do_something' })
      end
    end
  end

  describe "belongs to multiple optional parents" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register(Category)
        ActiveAdmin.register(User)
        ActiveAdmin.register(Post) { belongs_to :category, :user, optional: true }
      end
    end

    it "should route the nested index path belongs to Category" do
      expect(admin_category_posts_path(1)).to eq "/admin/categories/1/posts"
    end

    it "should route the nested show path belongs to Category" do
      expect(admin_category_post_path(1, 2)).to eq "/admin/categories/1/posts/2"
    end

    it "should route the nested new path belongs to Category" do
      expect(new_admin_category_post_path(1)).to eq "/admin/categories/1/posts/new"
    end

    it "should route the nested edit path belongs to Category" do
      expect(edit_admin_category_post_path(1, 2)).to eq "/admin/categories/1/posts/2/edit"
    end

    it "should route the nested index path belongs to User" do
      expect(admin_user_posts_path(1)).to eq "/admin/users/1/posts"
    end

    it "should route the nested show path belongs to User" do
      expect(admin_user_post_path(1, 2)).to eq "/admin/users/1/posts/2"
    end

    it "should route the nested new path belongs to User" do
      expect(new_admin_user_post_path(1)).to eq "/admin/users/1/posts/new"
    end

    it "should route the nested edit path belongs to User" do
      expect(edit_admin_user_post_path(1, 2)).to eq "/admin/users/1/posts/2/edit"
    end
  end

  describe "page" do
    context "when default namespace" do
      around do |example|
        with_resources_during(example) { ActiveAdmin.register_page("Chocolate I lØve You!") }
      end

      it "should route to the page under /admin" do
        expect(admin_chocolate_i_love_you_path).to eq "/admin/chocolate_i_love_you"
      end
    end

    context "when in the root namespace" do
      around do |example|
        with_resources_during(example) { ActiveAdmin.register_page("Chocolate I lØve You!", namespace: false) }
      end

      after do
        namespaces.instance_variable_get(:@namespaces).delete(:root)
      end

      it "should route to page under /" do
        expect(chocolate_i_love_you_path).to eq "/chocolate_i_love_you"
      end
    end

    context "when singular page name" do
      around do |example|
        with_resources_during(example) { ActiveAdmin.register_page("Log") }
      end

      it "should not inject _index_ into the route name" do
        expect(admin_log_path).to eq "/admin/log"
      end
    end
  end
end
