require 'spec_helper'
require File.expand_path('base_controller_shared_examples', File.dirname(__FILE__))

describe ActiveAdmin::BaseController do
  let(:controller) { ActiveAdmin::BaseController.new }

  it_should_behave_like "BaseController"
end
