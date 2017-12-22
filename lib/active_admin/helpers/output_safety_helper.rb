module ActiveAdmin
  module OutputSafetyHelper
    # Converts the array to a comma-separated sentence where the last element is
    # joined by the connector word. This is the html_safe-aware version of
    # ActiveSupport's {Array#to_sentence}[http://api.rubyonrails.org/classes/Array.html#method-i-to_sentence].
    #
    # Copied from Rails 5 to support Rails 4.
    # https://github.com/rails/rails/blob/9c35bf2a6a27431c6aa283db781c19f61c5155be/actionview/lib/action_view/helpers/output_safety_helper.rb#L43
    def to_sentence(array, options = {})
      options.assert_valid_keys(:words_connector, :two_words_connector, :last_word_connector, :locale)

      default_connectors = {
        words_connector: ", ",
        two_words_connector: " and ",
        last_word_connector: ", and "
      }
      if defined?(::I18n)
        i18n_connectors = ::I18n.translate(:'support.array', locale: options[:locale], default: {})
        default_connectors.merge!(i18n_connectors)
      end
      options = default_connectors.merge!(options)

      case array.length
      when 0
        "".html_safe
      when 1
        ERB::Util.html_escape(array[0])
      when 2
        safe_join([array[0], array[1]], options[:two_words_connector])
      else
        safe_join([safe_join(array[0...-1], options[:words_connector]), options[:last_word_connector], array[-1]], nil)
      end
    end
  end
end
