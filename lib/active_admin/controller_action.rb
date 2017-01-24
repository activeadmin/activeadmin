module ActiveAdmin
  class ControllerAction
    attr_reader :name, :http_verb

    def initialize(name, options = {})
      @name = name.to_sym
      @http_verb = resolve_http_verb(options)
    end

    def remove_http_verbs(verbs)
      self.http_verb = http_verb - verbs
    end

    private

    attr_writer :http_verb

    def resolve_http_verb(options)
      method = options[:method]
      return [:get] unless method

      Array(method).map { |m| m.downcase.to_sym }.uniq
    end
  end
end
