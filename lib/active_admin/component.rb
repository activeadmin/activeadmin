# frozen_string_literal: true
module ActiveAdmin
  class Component < Arbre::Component
    def initialize(*)
      super
      add_class default_class_name
    end

    def default_class_name
    end
  end
end
