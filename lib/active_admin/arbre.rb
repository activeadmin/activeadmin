require "active_admin/arbre/builder"
require "active_admin/arbre/context"
require "active_admin/arbre/html/element"
require "active_admin/arbre/html/attributes"
require "active_admin/arbre/html/collection"
require "active_admin/arbre/html/class_list"
require "active_admin/arbre/html/tag"
require "active_admin/arbre/html/document"
require "active_admin/arbre/html/html5_elements"
require "active_admin/arbre/html/text_node"

# Arbre - The DOM Tree in Ruby
#
# Arbre is a ruby library for building HTML in pure Object Oriented Ruby
module Arbre
end

require 'action_view'

ActionView::Template.register_template_handler :arb, lambda { |template|
  "self.class.send :include, Arbre::Builder; @_helpers = self; @__current_dom_element__ = Arbre::Context.new(assigns, self); begin; #{template.source}; end; current_dom_context.to_s"
}
