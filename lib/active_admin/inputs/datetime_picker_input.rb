module ActiveAdmin
  module Inputs
    class DatetimePickerInput < ::Formtastic::Inputs::StringInput
      def input_html_options
        super.tap do |options|
          options[:class] = [options[:class], "xdan-datetime-picker"].compact.join(' ')
          options[:data] ||= {}
          options[:data].merge! datepicker_options
          options[:value] ||= value
        end
      end

      def value
        val = object.send(method)
        return DateTime.new(val.year, val.month, val.day, val.hour, val.min).strftime("%Y-%m-%d %H:%M") if val.is_a?(Time)
        return val if val.nil?
        val.to_s
      end

      private
        def datepicker_options
          options = self.options.fetch(:datepicker_options, {})
          options = Hash[options.map{ |k, v| [k.to_s.camelcase(:lower), v] }]
          { datepicker_options: options }
        end
    end
  end
end
