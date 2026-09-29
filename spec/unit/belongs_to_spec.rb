# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Resource::BelongsTo do
  around do |example|
    with_resources_during(example) do
      ActiveAdmin.register User
      ActiveAdmin.register(Post) { belongs_to :user }
    end
  end

  let(:user_config) { ActiveAdmin.register User }
  let(:post_config) { ActiveAdmin.register(Post) { belongs_to :user } }
  let(:belongs_to) { post_config.belongs_to_config }

  it "should have an owner" do
    expect(belongs_to.owner).to eq post_config
  end

  describe "finding the target" do
    context "when the resource has been registered" do
      it "should return the target resource" do
        expect(belongs_to.target).to eq user_config
      end
    end

    context "when the resource has not been registered" do
      let(:belongs_to) { ActiveAdmin::Resource::BelongsTo.new post_config, :missing }

      it "should raise a ActiveAdmin::BelongsTo::TargetNotFound" do
        expect do
          belongs_to.target
        end.to raise_error(ActiveAdmin::Resource::BelongsTo::TargetNotFound)
      end
    end

    context "when the resource is on a namespace" do
      let(:blog_post_config) { ActiveAdmin.register Blog::Post }
      let(:belongs_to) { ActiveAdmin::Resource::BelongsTo.new blog_post_config, :blog_author, class_name: "Blog::Author" }
      before do
        class Blog::Author
          include ActiveModel::Naming
        end
        @blog_author_config = ActiveAdmin.register Blog::Author
      end
      it "should return the target resource" do
        expect(belongs_to.target).to eq @blog_author_config
      end
    end
  end

  it "should be optional" do
    belongs_to = ActiveAdmin::Resource::BelongsTo.new post_config, :user, optional: true
    expect(belongs_to).to be_optional
  end

  describe "controller" do
    let(:controller) { post_config.controller.new }
    let(:http_params) { { user_id: user.id } }
    let(:user) { User.create! }

    before do
      request = double "Request", format: "application/json"
      allow(controller).to receive(:params) { ActionController::Parameters.new(http_params) }
      allow(controller).to receive(:request) { request }
    end

    it "should be able to access the collection" do
      expect(controller.send :collection).to be_a ActiveRecord::Relation
    end

    it "should be able to build a new resource" do
      expect(controller.send :build_resource).to be_a Post
    end
  end

  describe "method_for_association_chain (with `defaults collection_name:`)" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register User
        ActiveAdmin.register(Post) do
          belongs_to :user, optional: true
          controller do
            defaults collection_name: :unstarred_posts
          end
        end
      end
    end

    let(:post_config) { ActiveAdmin.application.namespaces[:admin].resources["Post"] }
    let(:controller) { post_config.controller.new }
    let(:user) { User.create! }

    it "scopes through the configured collection name, which is the parent's association" do
      controller.params = ActionController::Parameters.new(user_id: user.id)

      expect(controller.send(:method_for_association_chain)).to eq(:unstarred_posts)
    end
  end

  describe "method_for_association_chain (with `as:` alias and `defaults collection_name:`)" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register User
        ActiveAdmin.register(Post, as: "Story") do
          belongs_to :user, optional: true
          controller do
            defaults collection_name: :unstarred_posts
          end
        end
      end
    end

    let(:post_config) { ActiveAdmin.application.namespaces[:admin].resources["Story"] }
    let(:controller) { post_config.controller.new }
    let(:user) { User.create! }

    it "prefers the collection name that was set over the alias's plural" do
      controller.params = ActionController::Parameters.new(user_id: user.id)

      expect(controller.send(:method_for_association_chain)).to eq(:unstarred_posts)
    end
  end

  describe "method_for_association_chain (when the alias's plural is a real association)" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register User
        ActiveAdmin.register(Post, as: "Highlight") do
          belongs_to :user, optional: true
        end
      end
    end

    let(:post_config) { ActiveAdmin.application.namespaces[:admin].resources["Highlight"] }
    let(:controller) { post_config.controller.new }
    let(:user) { User.create! }

    it "scopes through it rather than deriving the model's plural" do
      controller.params = ActionController::Parameters.new(user_id: user.id)

      expect(controller.send(:method_for_association_chain)).to eq(:highlights)
    end
  end

  describe "method_for_association_chain (with `as:` alias)" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register User
        ActiveAdmin.register(Post, as: "Story") { belongs_to :user, optional: true }
      end
    end

    let(:post_config) { ActiveAdmin.application.namespaces[:admin].resources["Story"] }
    let(:controller) { post_config.controller.new }
    let(:user) { User.create! }

    it "derives the parent's association name from the resource's model class" do
      controller.params = ActionController::Parameters.new(user_id: user.id)

      expect(controller.send(:method_for_association_chain)).to eq(:posts)
    end
  end

  describe "controller with an alias matching an unrelated association" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register Category
        ActiveAdmin.register(Post, as: "Author") { belongs_to :category }
      end
    end

    let(:post_config) { ActiveAdmin.application.namespaces[:admin].resources["Author"] }
    let(:controller) { post_config.controller.new }
    let(:category) { Category.create!(name: "News") }

    it "scopes through posts rather than the category's authors" do
      controller.params = ActionController::Parameters.new(category_id: category.id)

      expect(controller.send(:scoped_collection).klass).to eq(Post)
    end
  end

  describe "controller with optional nesting and scope_to" do
    around do |example|
      with_resources_during(example) do
        ActiveAdmin.register User
        ActiveAdmin.register(Post, as: "Article") do
          belongs_to :user, optional: true
          scope_to :current_category
        end
      end
    end

    let(:post_config) { ActiveAdmin.application.namespaces[:admin].resources["Article"] }
    let(:controller) { post_config.controller.new }
    let(:category) { Category.create!(name: "News") }

    it "uses the scope_to parent's association on the non-nested route" do
      controller.params = ActionController::Parameters.new
      allow(controller).to receive(:current_category).and_return(category)

      expect(controller.send(:scoped_collection).klass).to eq(Post)
    end
  end
end
