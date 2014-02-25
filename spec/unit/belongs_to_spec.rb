require 'spec_helper'

describe ActiveAdmin::Resource::BelongsTo do


  let(:application){ ActiveAdmin::Application.new }
  let(:namespace){ ActiveAdmin::Namespace.new(application, :admin) }
  let(:post){ namespace.register(Post) }
  let(:belongs_to){ ActiveAdmin::Resource::BelongsTo.new(post, :user) }

  it "should have an owner" do
    expect(belongs_to.owner).to eq post
  end

  it "should have a namespace" do
    expect(belongs_to.namespace).to eq namespace
  end

  describe "finding the target" do
    context "when the resource has been registered" do
      let(:user){ namespace.register(User) }
      before { user } # Ensure user is registered

      it "should return the target resource" do
        expect(belongs_to.target).to eq user
      end
    end

    context "when the resource has not been registered" do
      it "should raise a ActiveAdmin::BelongsTo::TargetNotFound" do
        expect {
          belongs_to.target
        }.to raise_error(ActiveAdmin::Resource::BelongsTo::TargetNotFound)
      end
    end
  end

  it "should be optional" do
    belongs_to = ActiveAdmin::Resource::BelongsTo.new post, :user, optional: true
    expect(belongs_to).to be_optional
  end
end
