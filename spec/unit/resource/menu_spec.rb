require 'rails_helper'

module ActiveAdmin
  describe Resource, "Menu" do

    before { load_defaults! }

    let(:application){ ActiveAdmin::Application.new }
    let(:namespace){ Namespace.new(application, :admin) }

    def config(options = {})
      @config ||= Resource.new(namespace, Category, options)
    end

    # TODO...

  end
end
