module ActiveAdmin
  module AssetRegistration

    def register_stylesheet(path, options = {})
      Deprecation.warn <<-MSG.strip_heredoc
        The `register_stylesheet` config is deprecated and will be removed
        in v2. Import your "#{path}" stylesheet in the active_admin.scss.
      MSG
      stylesheets[path] = options
    end

    def stylesheets
      @stylesheets ||= {}
    end

    def clear_stylesheets!
      stylesheets.clear
    end

    def register_javascript(name)
      Deprecation.warn <<-MSG.strip_heredoc
        The `register_javascript` config is deprecated and will be removed
        in v2. Import your "#{name}" javascript in the active_admin.js.
      MSG
      javascripts.add name
    end

    def javascripts
      @javascripts ||= Set.new
    end

    def clear_javascripts!
      javascripts.clear
    end

  end
end
