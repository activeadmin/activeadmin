module ActiveAdmin

  # Shareable module to give a #display_on?(action) method
  # which returns true or false depending on an options hash.
  #
  # The options hash accepts:
  #
  # :only => :index
  # :only => [:index, :show]
  # :except => :index
  # :except => [:index, :show]
  #
  # call #normalize_display_options! after @options has been set
  # to ensure that the display options are setup correctly

  module OptionalDisplay
    def display_on?(action, render_context = nil)
      return false if @options[:only] && !@options[:only].include?(action.to_sym)
      return false if @options[:except] && @options[:except].include?(action.to_sym)
      if @options[:if]
        symbol_or_proc = @options[:if]
        return case symbol_or_proc
        when Symbol, String
          render_context ? render_context.send(symbol_or_proc) : self.send(symbol_or_proc)
        when Proc
          render_context ? render_context.instance_exec(&symbol_or_proc) : instance_exec(&symbol_or_proc)
        else symbol_or_proc
        end
      end
      true
    end

    private

    def normalize_display_options!
      @options[:only] = Array(@options[:only]) if @options[:only]
      @options[:except] = Array(@options[:except]) if @options[:except]
    end
  end
end
