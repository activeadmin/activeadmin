require 'active_admin/localizers/resource_localizer'

module ActiveAdmin
  module Localizers
    class << self
      def resource(active_admin_config)
        ResourceLocalizer.from_resource(active_admin_config)
      end
    end
  end
end
