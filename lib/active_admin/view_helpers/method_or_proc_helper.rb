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

end
