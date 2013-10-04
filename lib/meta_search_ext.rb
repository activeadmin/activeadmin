# This fixes the edge case reported in #2504. There's no point putting
# in a pull request to meta_search, as it's no longer maintained :/
class MetaSearch::Builder
  alias original_repond_to? respond_to?
  def respond_to?(method, include_private = false)
    original_repond_to? method, include_private
  rescue
    false
  end
end
