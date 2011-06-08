module ActiveAdmin
  # Deals with reloading Active Admin on each request in 
  # development and once in production.
  class Reloader

    def initialize(rails_version)
      @rails_version = rails_version.to_s
    end

    def attach!
      reloader_class.to_prepare do
        ActiveAdmin.unload!
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
