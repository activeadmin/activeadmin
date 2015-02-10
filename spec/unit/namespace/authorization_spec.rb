require 'rails_helper'

describe ActiveAdmin::Resource, "authorization" do

  let(:app){ ActiveAdmin::Application.new }
  let(:namespace){ ActiveAdmin::Namespace.new(app, :admin) }
  let(:auth){ double }

  describe "authorization_adapter" do

    it "should return AuthorizationAdapter by default" do
      expect(app.authorization_adapter).to       eq ActiveAdmin::AuthorizationAdapter
      expect(namespace.authorization_adapter).to eq ActiveAdmin::AuthorizationAdapter
    end

    it "should be settable on the namespace" do
      namespace.authorization_adapter = auth
      expect(namespace.authorization_adapter).to eq auth
    end

    it "should be settable on the application" do
      app.authorization_adapter = auth
      expect(app.authorization_adapter).to eq auth
    end

  end
end
