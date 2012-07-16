module ActiveAdmin
  module ViewHelpers
    module FormHelper
      # @return [Array] of [Hash] with one element.
      # Example: [ {"scope" => "all"} , {"user[]" => "greg"} ]
      def fields_for_params(params, prefix=nil)
        params.map do |k, v|
          next if prefix.nil? && %w(controller action commit utf8).include?(k.to_s)

          if prefix
            k = "#{prefix}[#{k}]"
          end

          case v
          when String
            { k => v }
          when Hash
            fields_for_params(v, k)
          when Array
            v.map do |v|
              { "#{k}[]" => v }
            end
          else
            raise "I don't know what to do with #{v.class} params: #{v.inspect}"
          end
        end.flatten.compact
      end
    end
  end
end
