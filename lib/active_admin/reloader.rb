module ActiveAdmin

  module Reloader

    # Builds the proper Reloader implementation class given the
    # current version of Rails.
    #
    # @param [Rails::Application] rails_app The current rails application
    # @param [ActiveAdmin::Application] active_admin_app The current Active Admin app
    # @param [String] rails_version The version of Rails we're using. 
    #
    # @returns A concrete subclass of AbstractReloader
    def self.build(rails_app, active_admin_app, rails_version)
      reloader_class = rails_version[0..2] == "3.2" ? Rails32Reloader : RailsLessThan31Reloader
      reloader_class.new(rails_app, active_admin_app, rails_version)
    end

    class AbstractReloader

      attr_reader :active_admin_app, :rails_app, :rails_version

      def initialize(rails_app, active_admin_app, rails_version)
        @rails_app = rails_app
        @active_admin_app = active_admin_app
        @rails_version = rails_version.to_s
      end

      def attach!
        raise "Please implement #{self.class}#attach!"
      end

      def reload!
        active_admin_app.unload!
        rails_app.reload_routes!
      end

      def major_rails_version
        @rails_version[0..2]
      end

    end

    # Reloads the application when using Rails 3.2
    #
    # 3.2 introduced a to_prepare block that only gets called when
    # files have actually changed. ActiveAdmin had built this functionality
    # in to speed up applications. So in Rails >= 3.2, we can now piggy
    # back off the existing reloader. This simplifies our duties... which is
    # nice.
    class Rails32Reloader < AbstractReloader

      # Attach to Rails and perform the reload on each request.
      def attach!
        active_admin_app.load_paths.each do |path|
          rails_app.config.watchable_dirs[path] = [:rb]
        end

        reloader = self

        ActionDispatch::Reloader.to_prepare do
          reloader.reload!
        end
      end

    end

    # Deals with reloading Active Admin on each request in 
    # development and once in production in Rails < 3.2.
    class RailsLessThan31Reloader < AbstractReloader

      class FileUpdateChecker < ::ActiveSupport::FileUpdateChecker
        def paths
          # hack to support both Rails 3.1 and 3.2
          @files || @paths
        end

        # Over-ride the default #updated_at to support the deletion of files
        def updated_at
          paths.map { |path| File.mtime(path) rescue Time.now }.max
        end

        def execute_if_updated
          super
        end
      end

      attr_reader :file_update_checker

      def initialize(rails_app, active_admin_app, rails_version)
        super
        @file_update_checker = FileUpdateChecker.new(watched_paths) do
          reload!
        end
      end

      def reload!
        super
        file_update_checker.paths.clear
        watched_paths.each{|path| file_update_checker.paths << path }
      end


      # Attach to Rails and perform the reload on each request.
      def attach!
        # Bring the checker into local scope for the ruby block
        checker = file_update_checker

        reloader_class.to_prepare do
          checker.execute_if_updated
        end
      end

      def watched_paths
        paths = active_admin_app.load_paths
        active_admin_app.load_paths.each{|path| paths += Dir[File.join(path, "**", "*.rb")]}
        paths
      end

      def reloader_class
        if major_rails_version == "3.1"
          ActionDispatch::Reloader
        else
          ActionDispatch::Callbacks
        end
      end

    end

  end
end
