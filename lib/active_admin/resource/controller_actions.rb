module ActiveAdmin
  class Resource
    class ControllerActions
      def initialize
        @actions = []
      end

      def items
        copy
      end

      # Adds a new action to the collection.
      # Don't allow add actions with the same name and http method,
      # in order to avoid routes duplication.
      def <<(new_action)
        actions.each do |action|
          next if action.name != new_action.name

          new_action.remove_http_verbs(action.http_verb)
          return if new_action.http_verb.blank?
        end

        actions << new_action
      end

      def each(&block)
        copy.each(&block)
      end

      def size
        actions.size
      end

      private

      attr_accessor :actions

      def copy
        actions.dup
      end
    end
  end
end