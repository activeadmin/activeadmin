# frozen_string_literal: true
require "tmpdir"

# Lets a spec add view templates without touching the shared test app.
#
# Parallel workers all run against the same app directory, so a template
# written into app/views could be rendered by another worker's spec, or two
# specs could write the same path at once. Instead, templates go into a
# directory private to the current example, which is put first in the view
# lookup path and removed afterwards.
#
#   write_view "admin/posts/_form.html.erb", "<p>Custom form</p>"
module TemporaryViewsHelper
  def write_view(relative_path, contents)
    path = File.join(temporary_view_path, relative_path)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, contents)
  end

  private

  def temporary_view_path
    @temporary_view_path ||= Dir.mktmpdir("activeadmin-views").tap do |dir|
      @original_view_paths = ActionController::Base.view_paths
      ActionController::Base.prepend_view_path(dir)
    end
  end
end

RSpec.configure do |config|
  config.include TemporaryViewsHelper

  config.after do
    if @temporary_view_path
      ActionController::Base.view_paths = @original_view_paths
      FileUtils.rm_rf(@temporary_view_path)
    end
  end
end
