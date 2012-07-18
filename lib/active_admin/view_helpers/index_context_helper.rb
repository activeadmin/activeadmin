module IndexContextHelper
  def index_context_sentence(view)
    ContextSentence.new(view).to_sentence
  end

  class ContextSentence
    attr_reader :view

    def initialize(view)
      @view = view
    end

    def to_sentence
      [scope_sentence, plural_resource_name, filters_sentence].compact.join(' ') + "."
    end

    private

    def scope_sentence
      if view.params[:scope]
        scope = config.get_scope_by_id(view.params[:scope])
      else
        scope = config.default_scope
      end

      if scope
        I18n.t("active_admin.scopes.#{scope.id}", :default => scope.name)
      else
        'All'
      end
    end

    def filters_sentence
      return nil if search_attributes.empty?

      filters_token = search_attributes.map do |kv|
        filter_sentence(kv)
      end

      "with #{filters_token.to_sentence}"
    end

    def filter_sentence(kv)
      k, v = kv

      predicate = k[/(#{MetaSearch::DEFAULT_WHERES.map { |w| w.first }.join('|')})$/]
      attribute = k.sub(/_#{predicate}$/, '')
      value = v

      human_attribute = resource_class.human_attribute_name attribute

      human_predicate = case predicate
                        when 'contains', 'equals', 'in', nil # failed to extract predicate
                          nil
                        else
                          predicate.gsub('_', ' ')
                        end

      if attribute[/_id$/]
        # Association
        reflection_name = attribute.sub!(/_id$/, '').to_sym
        reflection_class = resource_class.reflect_on_association(reflection_name).klass
        reflection_instances = Array(reflection_class.find(value))

        value = reflection_instances.map do |instance|
          display_name(instance)
        end
      end

      human_value = value.is_a?(Array) ? value.join(', ') : value.to_s

      [human_attribute, human_predicate, %{"#{human_value}"}].compact.join ' '
    end

    def plural_resource_name
      config.plural_resource_label
    end

    def config
      view.active_admin_config
    end

    def resource_class
      config.resource_class
    end

    def search_attributes
      view.assigns[:search].try(:search_attributes) || []
    end

    # For #display_name
    include ::ActiveAdmin::ViewHelpers::DisplayHelper
    def active_admin_application
      view.active_admin_application
    end
  end
end
