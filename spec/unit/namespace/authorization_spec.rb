require 'spec_helper'

describe ActiveAdmin::Resource, "authorization" do

  let(:app){ ActiveAdmin::Application.new }
  let(:namespace){ ActiveAdmin::Namespace.new(app, :admin) }
  let(:mock_auth){ mock }

  describe "authorization_adapter" do

    it "should return AuthorizationAdapter by default" do
      namespace.authorization_adapter.should == ActiveAdmin::AuthorizationAdapter
    end

    it "should be settable on the namespace" do
      namespace.authorization_adapter.should == ActiveAdmin::AuthorizationAdapter
      namespace.authorization_adapter = mock_auth

      namespace.authorization_adapter.should == mock_auth
    end

    it "should be settable on the application" do
      namespace.authorization_adapter.should == ActiveAdmin::AuthorizationAdapter
      app.authorization_adapter = mock_auth

      namespace.authorization_adapter.should == mock_auth
    end

  end

end
