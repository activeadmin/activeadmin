require "active_admin/arbre/html"
require "active_admin/arbre/attributes"
require "active_admin/arbre/core_extensions"
require "active_admin/arbre/element"
require "active_admin/arbre/context"
require "active_admin/arbre/collection"
require "active_admin/arbre/class_list"
require "active_admin/arbre/tag"
require "active_admin/arbre/document"
require "active_admin/arbre/html5_elements"
require "active_admin/arbre/text_node"

# Arbre - The DOM Tree in Ruby
#
# Arbre is a ruby library for building HTML in pure Object Oriented Ruby
module Arbre
end

require 'action_view'

ActionView::Template.register_template_handler :arb, lambda { |template|
  "self.class.send :include, Arbre::HTML; @_helpers = self; @__current_dom_element__ = Arbre::Context.new(assigns, self); begin; #{template.source}; end; current_dom_context"
}
