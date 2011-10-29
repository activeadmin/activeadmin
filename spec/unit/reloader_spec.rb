require 'spec_helper'

# Ensure we have both constants to play with
begin
  ActionDispatch::Reloader
rescue
  module ActionDispatch; module Reloader; def self.to_prepare; end; end; end
end

begin
  ActionDispatch::Callbacks
rescue
  module ActionDispatch; module Callbacks; def self.to_prepare; end; end; end
end


describe ActiveAdmin::Reloader do

  let(:mock_app){ mock(:load_paths => []) }

  it "should use ActionDispatch::Reloader if rails 3.1" do
    reloader = ActiveAdmin::Reloader.new mock_app, '3.1.0'
    reloader.reloader_class.should == ActionDispatch::Reloader
  end

  it "should use ActionDispatch::Callbacks if rails 3.0" do
    reloader = ActiveAdmin::Reloader.new mock_app, '3.0.0'
    reloader.reloader_class.should == ActionDispatch::Callbacks
  end

  it "should initialize a new file update checker" do
    ActiveSupport::FileUpdateChecker.should_receive(:new).with(mock_app.load_paths).and_return(mock(:execute_if_updated => true))
    ActiveAdmin::Reloader.new(mock_app, '3.1.0').attach!
  end

end
