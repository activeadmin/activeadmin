namespace :js do

  desc "Compile the JS for Rails apps without Asset Pipeline"
  task :compile do
    require 'sprockets'
    require 'uglifier'
    require 'fileutils'

    root_dir = File.expand_path(File.join("..", ".."), __FILE__)
    js_dir = File.join(root_dir, "app", "assets", "javascripts", "active_admin")
    generated_file = File.join(root_dir, 'lib', 'generators', 'active_admin', 'assets', 'templates', '3.0', 'active_admin.js')

    # The base.js file requires jquery. We don't need jquery to
    # compile the assets, however Sprockets will try to look it up
    # and raise an exception. Insteaad, we move the file out of the directory
    # then put it back after we compile.
    base_js = File.join(js_dir, "base.js")
    tmp_base_js = File.join(root_dir, "base.js")
    FileUtils.mv base_js, tmp_base_js

    env = Sprockets::Environment.new
    env.js_compressor = ::Uglifier.new
    env.append_path js_dir

    File.open generated_file, "w+" do |f|
      f << env["application"]
    end

    FileUtils.mv tmp_base_js, base_js
  end

end
