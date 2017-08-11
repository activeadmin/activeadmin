module ActiveAdmin

  class SettingsNode
    def initialize(parent = nil)
      @parent = parent
    end

    def settings
      @settings ||= {}
    end

    protected

    def parent
      @parent ||= self.class.new
    end

    def has_key?(name)
      settings.has_key?(name.to_sym) || @parent && @parent.has_key?(name.to_sym)
    end

    def fetch(name)
      if settings.has_key?(name.to_sym)
        settings.fetch(name.to_sym)
      elsif @parent
        parent.fetch(name)
      end
    end

    def respond_to_missing?(method, include_private = false)
      has_key?(method.to_s.chomp '=') || super
    end

    def method_missing(method, *args)
      name = method.to_s
      if has_key?(name.chomp '=')
        if name.chomp! '='
          settings[name.to_sym] = args.first
        else
          fetch(name)
        end
      else
        super
      end
    end
  end
end
