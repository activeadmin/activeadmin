module MethodOrProcHelper

  # Many times throughout the views we want to either call a method on an object
  # or instance_exec a proc passing in the object as the first parameter. This
  # method takes care of this functionality.
  #
  #   call_method_or_proc_on(@my_obj, :size) same as @my_obj.size
  # OR
  #   proc = Proc.new{|s| s.size }
  #   call_method_or_proc_on(@my_obj, proc)
  #
  def call_method_or_proc_on(obj, symbol_or_proc, options = {})
    exec = options[:exec].nil? ? true : options[:exec]
    case symbol_or_proc
    when Symbol, String
      obj.send(symbol_or_proc.to_sym)
    when Proc
      if exec
        instance_exec(obj, &symbol_or_proc)
      else
        symbol_or_proc.call(obj)
      end
    end
  end

  # Many configuration options (Ex: site_title, title_image) could either be
  # static (String), methods (Symbol) or procs (Proc). This helper takes care of
  # returning the content when String or call call_method_or_proc_on when Symbol or Proc.
  #
  def render_or_call_method_or_proc_on(obj, string_symbol_or_proc, options = {})
    case string_symbol_or_proc
    when Symbol, Proc
      call_method_or_proc_on(obj, string_symbol_or_proc, options)
    when String
      string_symbol_or_proc
    end
  end
end
