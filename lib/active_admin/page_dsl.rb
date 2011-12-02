module ActiveAdmin
  # This is the class where all the register_page blocks are instance eval'd
  class PageDSL < DSL

    # Page content.
    #
    # The block should define the view using Arbre.
    #
    # Example:
    #
    #   ActiveAdmin.register "My Page" do
    #     content do
    #       para "Sweet!"
    #     end
    #   end
    #
    def content(options = {}, &block)
      config.set_page_presenter :index, ActiveAdmin::PagePresenter.new(options, &block)
    end
  end
end
