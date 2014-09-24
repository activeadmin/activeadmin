require 'rails_helper'

describe ActiveAdmin::Resource::BelongsTo do

  let(:user_config){ ActiveAdmin.register_resource User }
  let(:post_config){ ActiveAdmin.register_resource Post do belongs_to :user end }
  let(:belongs_to){ post_config.belongs_to_config }

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
      let(:belongs_to){ ActiveAdmin::Resource::BelongsTo.new post_config, :missing }

      it "should raise a ActiveAdmin::BelongsTo::TargetNotFound" do
        expect {
          belongs_to.target
        }.to raise_error(ActiveAdmin::Resource::BelongsTo::TargetNotFound)
      end
    end
  end

  it "should be optional" do
    belongs_to = ActiveAdmin::Resource::BelongsTo.new post_config, :user, optional: true
    expect(belongs_to).to be_optional
  end

  describe "controller" do
    let(:controller) { post_config.controller.new }
    before do
      user = User.create!
      request = double 'Request', format: 'application/json'
      allow(controller).to receive(:params) { {user_id: user.id} }
      allow(controller).to receive(:request){ request }
    end
    it 'should be able to access the collection' do
      expect(controller.send :collection).to be_a ActiveRecord::Relation
    end
    it 'should be able to build a new resource' do
      expect(controller.send :build_resource).to be_a Post
    end
  end
end
