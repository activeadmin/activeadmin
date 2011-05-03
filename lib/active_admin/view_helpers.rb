module ActiveAdmin
  module ViewHelpers

    # Require all ruby files in the view helpers dir
    Dir[File.expand_path('../view_helpers', __FILE__) + "/*.rb"].each{|f| require f }

    include AssignsWithIndifferentAccessHelper
    include RendererHelper
    include AutoLinkHelper
    include BreadcrumbHelper
    include DisplayHelper
    include IconHelper
    include MethodOrProcHelper
    include SidebarHelper
    include TableHelper
    include FormHelper
    include StatusTagHelper
    include FilterFormHelper
    include TitleHelper
    include ViewFactoryHelper

  end
end
