module ActiveAdmin
  module EnvironmentChecker

    def should_build_routes?
      if ENV['ACTIVE_ADMIN_ROUTING'].present? then routes_from_env
      else
        running_server? || running_console? || running_rake_routes?
      end
    end

    private

    def routes_from_env
      ActiveRecord::ConnectionAdapters::Column.value_to_boolean ENV['ACTIVE_ADMIN_ROUTING']
    end

    def running_server?
      !!defined? ::Rails::Server
    end

    def running_console?
      !!defined? ::Rails::Console
    end

    def running_rake_routes?
      File.basename($0) == "rake" && ARGV.grep(/routes/).any?
    end

  end
end
