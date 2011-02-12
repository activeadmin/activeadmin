module ActiveAdmin
  module ViewHelpers

    # Require all ruby files in the view helpers dir
    Dir[File.expand_path('../view_helpers', __FILE__) + "/*.rb"].each{|f| require f }

    include RendererHelper
    include BreadcrumbHelper
    include IconHelper
    include PaginationHelper
    include SortableHelper
    include SidebarHelper
    include TableHelper
    include FormHelper
    include StatusTagHelper
    include FilterFormHelper
    include TitleHelper
    include FlashMessageHelper
    include ViewFactoryHelper

  end
end
