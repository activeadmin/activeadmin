module ActiveAdmin
  # Deals with reloading Active Admin on each request in 
  # development and once in production.
  class Reloader

    # @param [String] rails_version
    #   The version of Rails we're using. We use this to switch between
    #   the correcr Rails reloader class.
    def initialize(app, rails_version)
      @app = app
      @rails_version = rails_version.to_s
    end

    # Attach to Rails and perform the reload on each request.
    def attach!
      file_update_checker = ActiveSupport::FileUpdateChecker.new(@app.load_paths) do
        Reloader.do_reload
      end

      reloader_class.to_prepare do
        ActiveAdmin.application.always_reload_paths ? Reloader.do_reload : file_update_checker.execute_if_updated
      end
    end

    def reloader_class
      if @rails_version[0..2] == '3.1'
        ActionDispatch::Reloader
      else
        ActionDispatch::Callbacks
      end
    end
    
    def self.do_reload
      ActiveAdmin.application.unload!
      Rails.application.reload_routes!
    end

  end
end
