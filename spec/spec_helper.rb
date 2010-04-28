$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_admin'

require 'rubygems'

TEST_RAILS_VERSION = ENV['RAILS'] || '3.0.0'

RAILS_ENV = 'test'

if TEST_RAILS_VERSION == '3.0.0'
  # Rails 3
  RAILS_ROOT = File.expand_path('../rails/rails-3.0.0', __FILE__)
  ENV['BUNDLE_GEMFILE'] = File.join(RAILS_ROOT, 'Gemfile')
  require RAILS_ROOT + '/config/environment'
  require 'rspec/rails'
  Rspec.configure do |config|

  end
  Rspec::Matchers.define :have_tag do |*args|
    match_unless_raises Test::Unit::AssertionFailedError do |response|
      tag = args.shift
      content = args.shift
      
      options = {
        :tag => tag
      }.merge(args[0] || {})
      
      options[:content] = content if content
      assert_tag(options)
    end
  end
else
  # Rails 2.3.5
  RAILS_ROOT = File.expand_path('../rails/rails-2.3.5', __FILE__)
  require RAILS_ROOT + '/config/environment'
  require 'spec/rails'
  require 'spec/autorun'  
  Spec::Runner.configure do |config|

  end
end


module ActiveAdminIntegrationSpecHelper

  module ::Admin
    class PostsController < ::ActiveAdmin::AdminController
    end
  end

  def admin_post_path(*args); "/posts/1"; end
  def edit_admin_post_path(*args); "/posts/1/edit"; end
  def admin_posts_path; "/posts"; end
  def new_admin_post_path(*args); "/posts/new"; end
 
end
