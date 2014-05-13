require 'spec_helper'

describe ActiveAdmin::Application do
  let(:application){ ActiveAdmin::Application.new }
  let(:controllers){ application.controllers_for_filters }

  it 'controllers_for_filters' do
    expect(application.controllers_for_filters).to eq [
      ActiveAdmin::BaseController, ActiveAdmin::Devise::SessionsController,
      ActiveAdmin::Devise::PasswordsController, ActiveAdmin::Devise::UnlocksController,
      ActiveAdmin::Devise::RegistrationsController, ActiveAdmin::Devise::ConfirmationsController
    ]
  end

  it 'before_filter' do
    controllers.each{ |c| expect(c).to receive(:before_filter).and_return(true) }
    application.before_filter :my_filter, only: :show
  end

  it 'skip_before_filter' do
    controllers.each{ |c| expect(c).to receive(:skip_before_filter).and_return(true) }
    application.skip_before_filter :my_filter, only: :show
  end

  it 'after_filter' do
    controllers.each{ |c| expect(c).to receive(:after_filter).and_return(true) }
    application.after_filter :my_filter, only: :show
  end

  it 'skip after_filter' do
    controllers.each{ |c| expect(c).to receive(:skip_after_filter).and_return(true) }
    application.skip_after_filter :my_filter, only: :show
  end

  it 'around_filter' do
    controllers.each{ |c| expect(c).to receive(:around_filter).and_return(true) }
    application.around_filter :my_filter, only: :show
  end

  it 'skip_filter' do
    controllers.each{ |c| expect(c).to receive(:skip_filter).and_return(true) }
    application.skip_filter :my_filter, only: :show
  end
end
