require 'spec_helper'

describe ActiveAdmin::ResourceController::Sidebars do
  let(:controller){ Admin::PostsController }

  context 'without before_filter' do
    before do
      ActiveAdmin.register Post
    end

    subject { find_before_filter controller, :skip_sidebar! }

    it { should set_skip_sidebar_to nil, for: controller }
  end

  describe '#skip_sidebar!' do
    before do
      ActiveAdmin.register Post do
        before_filter :skip_sidebar!
      end
    end

    subject { find_before_filter controller, :skip_sidebar! }

    it { should set_skip_sidebar_to true, for: controller }
  end

  def find_before_filter(controller, filter)
    #raise controller._process_action_callbacks.map(&:filter).inspect
    controller._process_action_callbacks.detect { |f| f.raw_filter == filter.to_sym }
  end

  RSpec::Matchers.define :set_skip_sidebar_to do |expected, options|
    match do |filter|
      object = options[:for].new
      object.send filter.raw_filter if filter
      @actual = object.instance_variable_get(:@skip_sidebar)
      expect(@actual).to eq expected
    end

    failure_message_for_should do |filter|
      message = "expected before_filter to set @skip_sidebar to '#{expected}', but was '#{@actual}'"
    end
  end
end
