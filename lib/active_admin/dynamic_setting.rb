# frozen_string_literal: true
module ActiveAdmin

  class DynamicSetting
    def self.build(setting, type)
      (type ? klass(type) : self).new(setting)
    end

    def self.klass(type)
      klass = "#{type.to_s.camelcase}Setting"
      raise ArgumentError, "Unknown type: #{type}" unless ActiveAdmin.const_defined?(klass)
      ActiveAdmin.const_get(klass)
    end

    def initialize(setting)
      @setting = setting
    end

    def value(*_args)
      @setting
    end
  end

  # Many configuration options (Ex: site_title, title_image) could either be
  # static (String), methods (Symbol) or procs (Proc). This wrapper takes care of
  # returning the content when String or using instance_eval when Symbol or Proc.
  #
  class StringSymbolOrProcSetting < DynamicSetting
    def value(context = self)
      case @setting
      when Symbol, Proc
        context.instance_eval(&@setting)
      else
        @setting
      end
    end
  end

end
