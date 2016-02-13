module ActiveAdmin
  module ViewHelpers
    module FormHelper

      # Flatten a params Hash to an array of fields.
      #
      # @param params [Hash]
      # @param options [Hash] :namespace and :except
      #
      # @return [Array] of [Hash] with one element.
      #
      # @example
      #   fields_for_params(scope: "all", users: ["greg"])
      #     => [ {"scope" => "all"} , {"users[]" => "greg"} ]
      #
      def fields_for_params(params, options = {})
        namespace = options[:namespace]
        except    = Array.wrap(options[:except]).map &:to_s
        params    = params.respond_to?(:to_unsafe_h) ? params.to_unsafe_h : params

        params.flat_map do |k, v|
          next if namespace.nil? && %w(controller action commit utf8).include?(k.to_s)
          next if except.include?(k.to_s)

          if namespace
            k = "#{namespace}[#{k}]"
          end

          case v
          when String
            { k => v }
          when Symbol
            { k => v.to_s }
          when Hash
            fields_for_params(v, namespace: k)
          when Array
            v.map do |v|
              { "#{k}[]" => v }
            end
          when nil
            { k => '' }
          when TrueClass,FalseClass
            { k => v }
          else
            raise "I don't know what to do with #{v.class} params: #{v.inspect}"
          end
        end.compact
      end
    end
  end
end
