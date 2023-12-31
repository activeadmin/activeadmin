# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    module ScopeNameHelper

      def scope_name(scope)
        case scope.name
        when Proc then
          self.instance_exec(&scope.name).to_s
        else
          scope.name.to_s
        end
      end

    end
  end
end
