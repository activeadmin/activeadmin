require 'rubygems'
require "bundler"
Bundler.setup

require 'rake'

task :setup do
  system "bundle exec rails new spec/rails/rails-3.0.0 -m spec/support/rails_template.rb"
end

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :default => :spec

namespace :spec do
  
  desc "Run specs for all versions of rails"
  task :all do
    puts "Runing for Rails 2.3.5"
    out = `rake spec`
    puts out
    puts "Running for Rails 3"
    out = `rake spec RAILS=3.0.0`
    puts out
  end
  
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "active_admin #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
