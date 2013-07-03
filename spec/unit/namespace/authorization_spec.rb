require 'spec_helper'

describe ActiveAdmin::Resource, "authorization" do

  let(:app){ ActiveAdmin::Application.new }
  let(:namespace){ ActiveAdmin::Namespace.new(app, :admin) }
  let(:mock_auth){ mock }

  describe "authorization_adapter" do

    it "should return AuthorizationAdapter by default" do
      app.authorization_adapter.should       eq ActiveAdmin::AuthorizationAdapter
      namespace.authorization_adapter.should eq ActiveAdmin::AuthorizationAdapter
    end

    it "should be settable on the namespace" do
      namespace.authorization_adapter = mock_auth
      namespace.authorization_adapter.should eq mock_auth
    end

    it "should be settable on the application" do
      app.authorization_adapter = mock_auth
      app.authorization_adapter.should eq mock_auth
    end

  end
end
