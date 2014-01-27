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

end
