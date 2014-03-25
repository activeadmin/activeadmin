require 'spec_helper'

describe "Breadcrumbs" do

  include ActiveAdmin::ViewHelpers

  describe "generating a trail from paths" do

    def params; {}; end
    def link_to(name, url); {name: name, path: url}; end

    actions = ActiveAdmin::BaseController::ACTIVE_ADMIN_ACTIONS

    let(:user)        { double display_name: 'Jane Doe' }
    let(:user_config) { double find_resource: user, resource_name: double(route_key: 'users'),
                               defined_actions: actions }
    let(:post)        { double display_name: 'Hello World' }
    let(:post_config) { double find_resource: post, resource_name: double(route_key: 'posts'),
                               defined_actions: actions, belongs_to_config: double(target: user_config) }

    let :active_admin_config do
      post_config
    end

    let(:trail) { breadcrumb_links(path) }

    context "when request '/admin'" do
      let(:path) { "/admin" }

      it "should not have any items" do
        expect(trail.size).to eq 0
      end
    end

    context "when path '/admin/users'" do
      let(:path) { "/admin/users" }

      it "should have one item" do
        expect(trail.size).to eq 1
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
    end

    context "when path '/admin/users/1'" do
      let(:path) { "/admin/users/1" }

      it "should have 2 items" do
        expect(trail.size).to eq 2
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
      it "should have a link to /admin/users" do
        expect(trail[1][:name]).to eq "Users"
        expect(trail[1][:path]).to eq "/admin/users"
      end
    end

    context "when path '/admin/users/1/posts'" do
      let(:path) { "/admin/users/1/posts" }

      it "should have 3 items" do
        expect(trail.size).to eq 3
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
      it "should have a link to /admin/users" do
        expect(trail[1][:name]).to eq "Users"
        expect(trail[1][:path]).to eq "/admin/users"
      end

      context "when User.find(1) doesn't exist" do
        before { user_config.stub(find_resource: nil) }
        it "should have a link to /admin/users/1" do
          expect(trail[2][:name]).to eq "1"
          expect(trail[2][:path]).to eq "/admin/users/1"
        end
      end

      context "when User.find(1) does exist" do
        it "should have a link to /admin/users/1 using display name" do
          expect(trail[2][:name]).to eq "Jane Doe"
          expect(trail[2][:path]).to eq "/admin/users/1"
        end
      end
    end

    context "when path '/admin/users/4e24d6249ccf967313000000/posts'" do
      let(:path) { "/admin/users/4e24d6249ccf967313000000/posts" }

      it "should have 3 items" do
        expect(trail.size).to eq 3
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
      it "should have a link to /admin/users" do
        expect(trail[1][:name]).to eq "Users"
        expect(trail[1][:path]).to eq "/admin/users"
      end

      context "when User.find(4e24d6249ccf967313000000) doesn't exist" do
        before { user_config.stub(find_resource: nil) }
        it "should have a link to /admin/users/4e24d6249ccf967313000000" do
          expect(trail[2][:name]).to eq "4e24d6249ccf967313000000"
          expect(trail[2][:path]).to eq "/admin/users/4e24d6249ccf967313000000"
        end
      end

      context "when User.find(4e24d6249ccf967313000000) does exist" do
        before do
          user_config.stub find_resource: double(display_name: 'Hello :)')
        end
        it "should have a link to /admin/users/4e24d6249ccf967313000000 using display name" do
          expect(trail[2][:name]).to eq "Hello :)"
          expect(trail[2][:path]).to eq "/admin/users/4e24d6249ccf967313000000"
        end
      end
    end

    context "when path '/admin/users/1/coments/1'" do
      let(:path) { "/admin/users/1/posts/1" }

      it "should have 4 items" do
        expect(trail.size).to eq 4
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
      it "should have a link to /admin/users" do
        expect(trail[1][:name]).to eq "Users"
        expect(trail[1][:path]).to eq "/admin/users"
      end
      it "should have a link to /admin/users/1" do
        expect(trail[2][:name]).to eq "Jane Doe"
        expect(trail[2][:path]).to eq "/admin/users/1"
      end
      it "should have a link to /admin/users/1/posts" do
        expect(trail[3][:name]).to eq "Posts"
        expect(trail[3][:path]).to eq "/admin/users/1/posts"
      end
    end

    context "when path '/admin/users/1/coments/1/edit'" do
      let(:path) { "/admin/users/1/posts/1/edit" }

      it "should have 5 items" do
        expect(trail.size).to eq 5
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
      it "should have a link to /admin/users" do
        expect(trail[1][:name]).to eq "Users"
        expect(trail[1][:path]).to eq "/admin/users"
      end
      it "should have a link to /admin/users/1" do
        expect(trail[2][:name]).to eq "Jane Doe"
        expect(trail[2][:path]).to eq "/admin/users/1"
      end
      it "should have a link to /admin/users/1/posts" do
        expect(trail[3][:name]).to eq "Posts"
        expect(trail[3][:path]).to eq "/admin/users/1/posts"
      end
      it "should have a link to /admin/users/1/posts/1" do
        expect(trail[4][:name]).to eq "Hello World"
        expect(trail[4][:path]).to eq "/admin/users/1/posts/1"
      end
    end

    context "when the 'show' action is disabled" do
      let(:post_config) { double find_resource: post, resource_name: double(route_key: 'posts'),
                                 defined_actions: actions - [:show], # this is the change
                                 belongs_to_config: double(target: user_config) }

      let(:path) { "/admin/posts/1/edit" }

      it "should have 3 items" do
        expect(trail.size).to eq 3
      end
      it "should have a link to /admin" do
        expect(trail[0][:name]).to eq "Admin"
        expect(trail[0][:path]).to eq "/admin"
      end
      it "should have a link to /admin/posts" do
        expect(trail[1][:name]).to eq "Posts"
        expect(trail[1][:path]).to eq "/admin/posts"
      end
      it "should not link to the show view for the post" do
        expect(trail[2]).to eq "Hello World"
      end
    end

  end
end
