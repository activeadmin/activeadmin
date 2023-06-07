# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers

    # Require all ruby files in the view helpers dir
    Dir[File.expand_path("view_helpers", __dir__) + "/*.rb"].each { |f| require f }

    include ActiveAdminApplicationHelper
    include AutoLinkHelper
    include BreadcrumbHelper
    include DisplayHelper
    include MethodOrProcHelper
    include SidebarHelper
    include FormHelper
    include TitleHelper
    include ViewFactoryHelper
    include FlashHelper
    include ScopeNameHelper

  end
end
