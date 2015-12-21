module ActiveAdmin
  # Exception class to raise when there is an authorized access
  # exception thrown. The exception has a few goodies that may
  # be useful for capturing / recognizing security issues.
  class AccessDenied < StandardError
    attr_reader :user, :action, :subject

    def initialize(user, action, subject)
      @user, @action, @subject = user, action, subject

      super()
    end

    def message
      I18n.t("active_admin.access_denied.message")
    end
  end

  class Error < RuntimeError
  end

  class ErrorLoading < Error
    # Locates the most recent file and line from the caught exception's backtrace.
    def find_cause(folder, backtrace)
      backtrace.grep(/\/(#{folder}\/.*\.rb):(\d+)/){ [$1, $2] }.first
    end
  end

  class DatabaseHitDuringLoad < ErrorLoading
    def initialize(exception)
      file, line = find_cause(:app, exception.backtrace)

      super "Your file, #{file} (line #{line}), caused a database error while Active Admin was loading. This " +
            "is most common when your database is missing or doesn't have the latest migrations applied. To " +
            "prevent this error, move the code to a place where it will only be run when a page is rendered. " +
            "One solution can be, to wrap the query in a Proc. " +
            "Original error message: #{exception.message}"
    end

    def self.capture
      yield
    rescue *database_error_classes => exception
      raise new exception
    end

    private

    def self.database_error_classes
      @classes ||= []
    end
  end

  class DependencyError < ErrorLoading
  end

  class NoMenuError < KeyError
  end

  class GeneratorError < Error
  end

end
