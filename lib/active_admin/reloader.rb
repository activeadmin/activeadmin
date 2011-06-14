module ActiveAdmin
  # Deals with reloading Active Admin on each request in 
  # development and once in production.
  class Reloader

    # @param [String] rails_version
    #   The version of Rails we're using. We use this to switch between
    #   the correcr Rails reloader class.
    def initialize(rails_version)
      @rails_version = rails_version.to_s
    end

    # Attach to Rails and perform the reload on each request.
    def attach!
      reloader_class.to_prepare do
        ActiveAdmin.application.unload!
        Rails.application.reload_routes!
      end
    end

    def reloader_class
      if @rails_version[0..2] == '3.1'
        ActionDispatch::Reloader
      else
        ActionDispatch::Callbacks
      end
    end

  end
end
