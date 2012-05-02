module ActiveAdmin
  class ControllerAction
    attr_reader :name, :options
    def initialize(name, options = {})
      @name, @options = name, options
    end

    def http_verb
      @options[:method] ||= :get
    end

    def action_name
      @options[:action] || @name
    end
  end
end
