module ActiveAdmin
  module Inputs
    class FilterNumericInput < ::Formtastic::Inputs::NumberInput
      include FilterBase
      include FilterBase::SearchMethodSelect

      def default_filters
        [ [I18n.t('active_admin.equal_to'),     'eq'],
          [I18n.t('active_admin.greater_than'), 'gt'],
          [I18n.t('active_admin.less_than'),    'lt'] ]
      end
    end
  end
end
