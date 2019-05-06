# Utility methods for internal use.
# @private
module MethodOrProcHelper
  extend self

  # This method will either call the symbol on self or instance_exec the Proc
  # within self. Any args will be passed along to the method dispatch.
  #
  # Calling with a Symbol:
  #
  #     call_method_or_exec_proc(:to_s) #=> will call #to_s
  #
  # Calling with a Proc
  #
  #     my_proc = Proc.new{ to_s }
  #     call_method_or_exec_proc(my_proc) #=> will instance_exec in self
  #
  def call_method_or_exec_proc(symbol_or_proc, *args)
    case symbol_or_proc
    when Symbol, String
      send(symbol_or_proc, *args)
    when Proc
      instance_exec(*args, &symbol_or_proc)
    else
      symbol_or_proc
    end
  end

  # Many times throughout the views we want to either call a method on an object
  # or instance_exec a proc passing in the object as the first parameter. This
  # method wraps that pattern.
  #
  # Calling with a String or Symbol:
  #
  #     call_method_or_proc_on(@my_obj, :size) same as @my_obj.size
  #
  # Calling with a Proc:
  #
  #     proc = Proc.new{|s| s.size }
  #     call_method_or_proc_on(@my_obj, proc)
  #
  # By default, the Proc will be instance_exec'd within self. If you would rather
  # not instance exec, but just call the Proc, then pass along `exec: false` in
  # the options hash.
  #
  #     proc = Proc.new{|s| s.size }
  #     call_method_or_proc_on(@my_obj, proc, exec: false)
  #
  # You can pass along any necessary arguments to the method / Proc as arguments. For
  # example:
  #
  #     call_method_or_proc_on(@my_obj, :find, 1) #=> @my_obj.find(1)
  #
  def call_method_or_proc_on(receiver, *args)
    options = { exec: true }.merge(args.extract_options!)

    symbol_or_proc = args.shift

    case symbol_or_proc
    when Symbol, String
      receiver.public_send symbol_or_proc.to_sym, *args
    when Proc
      if options[:exec]
        instance_exec(receiver, *args, &symbol_or_proc)
      else
        symbol_or_proc.call(receiver, *args)
      end
    else
      symbol_or_proc
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
    else
      string_symbol_or_proc
    end
  end

  # This method is different from the others in that it calls `instance_exec` on the receiver,
  # passing it the proc. This evaluates the proc in the context of the receiver, thus changing
  # what `self` means inside the proc.
  def render_in_context(context, obj, *args)
    context = self if context.nil? # default to `self` only when nil
    case obj
    when Proc
      context.instance_exec *args, &obj
    when Symbol
      context.public_send obj, *args
    else
      obj
    end
  end
end
