# frozen_string_literal: true
module ActiveAdmin
  module ViewHelpers
    # Require all ruby files in the view helpers dir
    Dir[File.expand_path("view_helpers", __dir__) + "/*.rb"].each { |f| require f }

    include MethodOrProcHelper
  end
end
