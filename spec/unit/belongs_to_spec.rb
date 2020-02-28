require 'rails_helper'

RSpec.describe ActiveAdmin::Resource::BelongsTo do
  before do
    load_resources do
      category_config
      user_config
      post_config
    end
  end

  let(:namespace) { ActiveAdmin.application.namespace(:admin) }
  let(:category_config) { ActiveAdmin.register Category }
  let(:user_config) { ActiveAdmin.register User }
  let(:post_config) { ActiveAdmin.register(Post) { belongs_to :user } }
  let(:belongs_to) { post_config.belongs_to_config }

  it "should have an owner" do
    expect(belongs_to.owner).to eq post_config
  end

  describe "finding the target" do
    context "when the resource has been registered" do
      it "should return the target resource" do
        expect(belongs_to.targets).to contain_exactly(user_config)
      end
    end

    context "when the resource has not been registered" do
      let(:belongs_to) { ActiveAdmin::Resource::BelongsTo.new post_config, [:missing] }

      it "should raise a ActiveAdmin::Resource::BelongsTo::TargetNotFound" do
        expect {
          belongs_to.targets
        }.to raise_error(ActiveAdmin::Resource::BelongsTo::TargetNotFound)
      end
    end

    context "when the resource is on a namespace" do
      let(:blog_post_config) { ActiveAdmin.register Blog::Post do; end }
      let(:belongs_to) { ActiveAdmin::Resource::BelongsTo.new blog_post_config, [:blog_author], class_name: "Blog::Author" }
      before do
        class Blog::Author
          include ActiveModel::Naming
        end
        @blog_author_config = ActiveAdmin.register Blog::Author do; end
      end
      it "should return the target resource" do
        expect(belongs_to.targets).to contain_exactly(@blog_author_config)
      end
    end
  end

  it "should be optional" do
    belongs_to = ActiveAdmin::Resource::BelongsTo.new post_config, [:user], optional: true
    expect(belongs_to).to be_optional
  end

  describe "with multiple optional targets" do
    let(:post_config) { ActiveAdmin.register(Post) { belongs_to :category, :user, optional: true } }

    it "should be optional" do
      expect(belongs_to).to be_optional
    end

    it "should return the target resources" do
      expect(belongs_to.targets).to contain_exactly(category_config, user_config)
    end
  end

  describe "with multiple non-optional targets" do
    it "should raise a ActiveAdmin::Resource::BelongsTo::NotSupported" do
      expect {
        ActiveAdmin.register(Post) { belongs_to :category, :user }
      }.to raise_error(ActiveAdmin::Resource::BelongsTo::NotSupported)
    end
  end

  describe "controller" do
    let(:controller) { post_config.controller.new }
    let(:http_params) { { user_id: user.id } }
    let(:user) { User.create! }

    before do
      request = double 'Request', format: 'application/json'
      allow(controller).to receive(:params) { ActionController::Parameters.new(http_params) }
      allow(controller).to receive(:request) { request }
    end

    it 'should be able to access the collection' do
      expect(controller.send :collection).to be_a ActiveRecord::Relation
    end
    it 'should be able to build a new resource' do
      expect(controller.send :build_resource).to be_a Post
    end
  end
end
