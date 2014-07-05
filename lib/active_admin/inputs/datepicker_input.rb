module ActiveAdmin
  module Inputs
    class DatepickerInput < ::Formtastic::Inputs::StringInput
      def input_html_options
        super.tap do |options|
          options[:class] = [options[:class], "datepicker"].compact.join(' ')
          options[:data] ||= {}
          options[:data].merge! datepicker_options

          #set date to language format
          current_value = @object.send("#{method}")
          options[:value] = current_value.respond_to?(:strftime) ? current_value.strftime(I18n.t('date.formats.default')) : ""
        end
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
