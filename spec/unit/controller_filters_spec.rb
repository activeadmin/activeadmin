require 'spec_helper'

describe ActiveAdmin::Application do
  let(:application){ ActiveAdmin::Application.new }
  let(:controllers){ [ActiveAdmin::BaseController,            ActiveAdmin::Devise::SessionsController,
                      ActiveAdmin::Devise::UnlocksController, ActiveAdmin::Devise::PasswordsController] }

  it 'before_filter' do
    controllers.each{ |c| c.should_receive(:before_filter).and_return(true) }
    application.before_filter :my_filter, :only => :show
  end

  it 'skip_before_filter' do
    controllers.each{ |c| c.should_receive(:skip_before_filter).and_return(true) }
    application.skip_before_filter :my_filter, :only => :show
  end

  it 'after_filter' do
    controllers.each{ |c| c.should_receive(:after_filter).and_return(true) }
    application.after_filter :my_filter, :only => :show
  end

  it 'around_filter' do
    controllers.each{ |c| c.should_receive(:around_filter).and_return(true) }
    application.around_filter :my_filter, :only => :show
  end
end
