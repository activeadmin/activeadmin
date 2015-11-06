module ActiveAdmin

  # A simple object that gets used to present different aspects of views
  #
  # Initialize with a set of options and a block. The options become
  # available using hash style syntax.
  #
  # Usage:
  #
  #     presenter = PagePresenter.new as: :table do
  #       # some awesome stuff
  #     end
  #
  #     presenter[:as]    #=> :table
  #     presenter.block   #=> The block passed in to new
  #
  class PagePresenter

    attr_accessor :block, :options

    delegate :has_key?, :fetch, to: :options

    def initialize(options = {}, &block)
      @options, @block = options, block
    end
    def block
      extensions.inject(@block) do |stack, ext|
        Proc.new do |f|
          ext.call(f)
          stack.call(f)
        end
      end
    end
    def [](key)
      @options[key]
    end
    
    def extensions 
      @extensions ||= []
    end

  end
end
