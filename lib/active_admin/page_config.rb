module ActiveAdmin
  class PageConfig

    attr_reader :block

    def initialize(options = {}, &block)
      @options, @block = options, block
    end

    def [](key)
      @options[key]
    end
      
  end
end
