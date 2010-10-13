module ActiveAdmin
  module ViewHelpers

    # Require all ruby files in the view helpers dir
    Dir[File.expand_path('../view_helpers', __FILE__) + "/*.rb"].each{|f| require f }

    include RendererHelper
    include AdminNotesHelper
    include BreadcrumbHelper
    include PaginationHelper
    include SortableHelper
    include TableHelper
    include FormHelper
    include StatusTagHelper
    include FilterFormHelper
    include TitleHelper

  end
end
