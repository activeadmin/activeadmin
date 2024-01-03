# frozen_string_literal: true
module ActiveAdmin
  module IndexScopesHelper
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
