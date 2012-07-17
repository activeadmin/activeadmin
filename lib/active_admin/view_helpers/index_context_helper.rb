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
      [scope, plural_resource_name, filters].compact.join(' ') + "."
    end

    private

    def filters
      search = view.assigns[:search] 
      return nil if search.nil? || search.search_attributes.empty?

      filters_token = search.search_attributes.map do |kv|
        filter_to_sentence(kv)
      end

      "with #{filters_token.to_sentence}"
    end

    def filter_to_sentence(kv)
      k, v = kv

      predicate = k[/(contains|greater_than|lower_than|equal_to)$/]
      attribute = k.sub(/_#{predicate}$/, '')
      value = v

      human_attribute = config.resource.human_attribute_name attribute

      human_predicate = case predicate
                        when 'contains', 'equal_to'
                          nil
                        else
                          predicate.gsub('_', ' ')
                        end


      [human_attribute, human_predicate, %{"#{value}"}].compact.join ' '
    end

    def plural_resource_name
      config.plural_resource_label
    end

    def config
      view.active_admin_config
    end

    def scope
      'All'
    end
  end
end
