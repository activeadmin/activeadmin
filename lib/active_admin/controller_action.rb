module ActiveAdmin
  class ControllerAction
    attr_reader :name, :http_verb

    def initialize(name, options = {})
      @name = name.to_sym
      @http_verb = resolve_http_verb(options)
    end

    def remove_http_verb(verb)
      self.http_verb = Array(http_verb) - Array(verb)
    end

    private

    attr_writer :http_verb

    def resolve_http_verb(options)
      method = options[:method]
      return :get unless method

      if method.is_a?(Array)
        method.map(&:to_sym).uniq
      else
        method.to_sym
      end
    end
  end
end
