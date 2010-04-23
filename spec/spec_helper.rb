$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'active_admin'

require 'rubygems'

RAILS_ENV = 'test'
RAILS_ROOT = File.expand_path('../rails/2.3.5', __FILE__)

require RAILS_ROOT + '/config/environment'

require 'spec/rails'
require 'spec/autorun'


Spec::Runner.configure do |config|
  
end


module ActiveAdminIntegrationSpecHelper

  module ::Admin
    class PostsController < ::ActiveAdmin::BaseController
    end
  end

  def admin_post_path(*args); "/posts/1"; end
  def edit_admin_post_path(*args); "/posts/1/edit"; end
  def admin_posts_path; "/posts"; end
  def amin_new_post_path; "/posts/new"; end
 
end
