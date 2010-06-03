require 'ostruct'

module ActiveAdmin
  class FormBuilder
    
    attr_reader :calls, :block
    
    def initialize(&block)
      @calls = []
      @buffer = @calls
      @block = block
      block.call(self)
    end
    
    def method_missing(*args)
      @buffer << ::OpenStruct.new(:name => args.shift, :args => args, :children => [])
      if block_given?
        with_new_buffer(@buffer.last.children) do
          yield self
        end
      end
    end
    
    def to_erb
      @indent = 0
      @erb = ""
      @calling_on = 'f'
      @calls.each do |c|
        method_to_erb(c)
      end
      @erb
    end
    
    def method_to_erb(c)
      has_block = c.children.any?
      options = c.args.last.is_a?(Hash) ? c.args.last : {}
      @erb << "#{@indent.times.collect{' '}}<%#{'=' unless has_block} #{@calling_on}.#{c.name} #{c.args.collect{|a| a.inspect}.join(', ')} #{"do" if has_block} #{"|" + options[:for].to_s + "_form|" if options[:for]} %>\n"
      if has_block
        old_calling_on = @calling_on
        @calling_on = "#{options[:for].to_s}_form" if options[:for]
        @indent += 2
        c.children.each{|child| method_to_erb(child)}
        @indent -= 2
        @calling_on = old_calling_on 
        @erb << "<% end %>\n"
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
