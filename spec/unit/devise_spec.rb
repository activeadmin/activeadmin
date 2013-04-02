require 'spec_helper'

describe ActiveAdmin::Devise::Controller do

  let(:controller_class) do
    klass = Class.new do
      def self.layout(*); end
      def self.helper(*); end
    end
    klass.send(:include, ActiveAdmin::Devise::Controller)
    klass
  end

  let(:controller) { controller_class.new }
  
  context 'with a RAILS_RELATIVE_URL_ROOT set' do
    
    before { Rails.configuration.action_controller[:relative_url_root] = '/foo' }
    
    it "should set the root path to the default namespace" do
      controller.root_path.should == "/foo/admin"
    end

    it "should set the root path to '/' when no default namespace" do
      ActiveAdmin.application.stub!(:default_namespace => false)
      controller.root_path.should == "/foo/"
    end
    
  end
  
  context 'without a RAILS_RELATIVE_URL_ROOT set' do
    
    before { Rails.configuration.action_controller[:relative_url_root] = nil }
    
    it "should set the root path to the default namespace" do
      controller.root_path.should == "/admin"
    end
    
    it "should set the root path to '/' when no default namespace" do
      ActiveAdmin.application.stub!(:default_namespace => false)
      controller.root_path.should == "/"
    end
    
  end

  context "within a scoped route" do

    SCOPE = '/aa_scoped'

    before do
      # Remove existing routes
      routes = Rails.application.routes
      routes.clear!

      # Add scoped routes
      routes.draw do
        scope :path => SCOPE do
          ActiveAdmin.routes(self)
          devise_for :admin_users, ActiveAdmin::Devise.config
        end
      end
    end

    after do
      # Resume default routes
      reload_routes!
    end

    it "should include scope path in root_path" do
      controller.root_path.should == "#{SCOPE}/admin"
    end

  end
  
  describe "#config" do
    let(:config) { ActiveAdmin::Devise.config }

    describe ":sign_out_via option" do

      subject { config[:sign_out_via] }

      context "when Devise does not implement sign_out_via (version < 1.2)" do
        before do
          ::Devise.should_receive(:respond_to?).with(:sign_out_via).and_return(false)
        end

        it "should not contain any customization for sign_out_via" do
          config.should_not have_key(:sign_out_via)
        end
      end

      context "when Devise implements sign_out_via (version >= 1.2)" do
        before do
          ::Devise.should_receive(:respond_to?).with(:sign_out_via).and_return(true)
          ::Devise.stub!(:sign_out_via) { :delete }
        end

        it "should contain the application.logout_link_method" do
            ::Devise.should_receive(:sign_out_via).and_return(:delete)
            ActiveAdmin.application.should_receive(:logout_link_method).and_return(:get)

            config[:sign_out_via].should include(:get)
        end

        it "should contain Devise's logout_via_method(s)" do
            ::Devise.should_receive(:sign_out_via).and_return([:delete, :post])
            ActiveAdmin.application.should_receive(:logout_link_method).and_return(:get)

            config[:sign_out_via].should == [:delete, :post, :get]
        end
      end

    end # describe ":sign_out_via option"
  end # describe "#config"

end
