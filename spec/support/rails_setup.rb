require 'rails/version'
ENV['RAILS_ROOT'] = File.expand_path("../../../test-rails/rails-#{Rails::VERSION::STRING}", __FILE__)

unless Dir.exists?(ENV['RAILS_ROOT'])
  system "bundle exec rails new #{ENV['RAILS_ROOT']} --skip_gemfile --skip_test_unit -m spec/support/rails_template.rb"
end

# Ensure the Active Admin load path is happy
require 'rails'
require 'active_admin'
ActiveAdmin.application.load_paths = [ENV['RAILS_ROOT'] + "/app/admin"]

require ENV['RAILS_ROOT'] + '/config/environment'
