require 'spec_helper_without_rails'

ENV['RAILS_ENV'] = 'test'

require 'support/rails_setup'

require 'rspec'
require 'rspec/rails'

# Setup Some Admin stuff for us to play with
require 'support/active_admin_integration_spec_helper'
include ActiveAdminIntegrationSpecHelper
load_defaults!
reload_routes!

# Disabling authentication in specs so that we don't have to worry about
# it allover the place
ActiveAdmin.application.authentication_method = false
ActiveAdmin.application.current_user_method = false

# Don't add asset cache timestamps. Makes it easy to integration
# test for the presence of an asset file
ENV["RAILS_ASSET_ID"] = ''

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
  config.include Devise::TestHelpers, :type => :controller
  config.render_views = false
end

# All RSpec configuration needs to happen before any examples
# or else it whines.
require 'support/integration_example_group'
RSpec.configure do |c|
  c.include RSpec::Rails::IntegrationExampleGroup, :example_group => { :file_path => /\bspec\/integration\// }
  c.include Devise::TestHelpers, :type => :controller
end

RSpec::Matchers.define :have_tag do |*args|
  match_unless_raises Test::Unit::AssertionFailedError do |response|
    tag = args.shift
    content = args.first.is_a?(Hash) ? nil : args.shift

    options = {
      :tag => tag.to_s
    }.merge(args[0] || {})

    options[:content] = content if content

    begin
      begin
        assert_tag(options)
      rescue NoMethodError
        # We are not in a controller, so let's do the checking ourselves
        doc = HTML::Document.new(response, false, false)
        tag = doc.find(options)
        assert tag, "expected tag, but no tag found matching #{options.inspect} in:\n#{response.inspect}"
      end
    # In Ruby 1.9, MiniTest::Assertion get's raised, so we'll
    # handle raising a Test::Unit::AssertionFailedError
    rescue MiniTest::Assertion => e
      raise Test::Unit::AssertionFailedError, e.message
    end
  end
end

# improve the performance of the specs suite by not logging anything
# see http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
Rails.logger.level = 4


# Improves performance by forcing the garbage collector to run less often.
unless ENV['DEFER_GC'] == '0' || ENV['DEFER_GC'] == 'false'
  require 'support/deferred_garbage_collection'
  RSpec.configure do |config|
    config.before(:all) { DeferredGarbageCollection.start }
    config.after(:all)  { DeferredGarbageCollection.reconsider }
  end
end
