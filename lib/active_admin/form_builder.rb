require 'ostruct'

module ActiveAdmin
  class FormBuilder
    
    attr_reader :calls
    
    def initialize(&block)
      @calls = []
      @buffer = @calls
      block.call(self)
    end
    
    def method_missing(*args)
      @buffer << OpenStruct.new(:name => args.shift, :args => args, :children => [])
      if block_given?
        with_new_buffer(@buffer.last.children) do
          yield self
        end
      end
    end
    
    private
    
    def with_new_buffer(new_buffer)
      old_buffer = @buffer
      @buffer = new_buffer
      yield
      @buffer = old_buffer      
    end
    
  end
end