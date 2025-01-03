# frozen_string_literal: true
module ActiveAdmin
  module FormHelper
    RESERVED_PARAMS = %w(controller action commit utf8).freeze

    def active_admin_form_for(resource, options = {}, &block)
      Arbre::Context.new({}, self) do
        active_admin_form_for resource, options, &block
      end.content
    end

    def hidden_field_tags_for(params, options = {})
      fields_for_params(params.to_unsafe_hash, options).map do |kv|
        k, v = kv.first
        hidden_field_tag k, v, id: sanitize_to_id("hidden_active_admin_#{k}")
      end.join("\n").html_safe
    end

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
      except = Array.wrap(options[:except]).map(&:to_s)

      params.flat_map do |k, v|
        next if namespace.nil? && RESERVED_PARAMS.include?(k.to_s)
        next if except.include?(k.to_s)

        if namespace
          k = "#{namespace}[#{k}]"
        end

        case v
        when String, TrueClass, FalseClass
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
          { k => "" }
        else
          raise TypeError, "Cannot convert #{v.class} value: #{v.inspect}"
        end
      end.compact
    end

    # Helper method to render a filter form
    def active_admin_filters_form_for(search, filters, options = {})
      defaults = { builder: ActiveAdmin::Filters::FormBuilder, url: collection_path, html: { class: "filters-form" } }
      required = { html: { method: :get }, as: :q }
      options = defaults.deep_merge(options).deep_merge(required)

      form_for search, options do |f|
        f.template.concat hidden_field_tags_for(params, except: except_hidden_fields)

        filters.each do |attribute, opts|
          next if opts.key?(:if) && !call_method_or_proc_on(self, opts[:if])
          next if opts.key?(:unless) && call_method_or_proc_on(self, opts[:unless])

          filter_opts = opts.except(:if, :unless)
          filter_opts[:input_html] = instance_exec(&filter_opts[:input_html]) if filter_opts[:input_html].is_a?(Proc)

          f.filter attribute, filter_opts
        end

        buttons = content_tag :div, class: "filters-form-buttons" do
          f.submit(I18n.t("active_admin.filters.buttons.filter"), class: "filters-form-submit") +
            link_to(I18n.t("active_admin.filters.buttons.clear"), collection_path, class: "filters-form-clear")
        end

        f.template.concat buttons
      end
    end

    private

    def except_hidden_fields
      [:q, :page]
    end
  end
end
