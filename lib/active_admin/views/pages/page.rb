# frozen_string_literal: true
module ActiveAdmin
  module Views
    module Pages
      class Page < Arbre::Element
        def build(*args)
          set_page_title(title)
          div class: "main-content-container" do
            main_content
          end
        end

        delegate :active_admin_config, :controller, :params, to: :helpers

        def main_content
          if page_presenter.block
            instance_exec &page_presenter.block
          else
            nil
          end
        end

        protected

        def page_presenter
          active_admin_config.get_page_presenter(:index) || ActiveAdmin::PagePresenter.new
        end

        def title
          if page_presenter[:title]
            render_or_call_method_or_proc_on self, page_presenter[:title]
          else
            active_admin_config.name
          end
        end
      end
    end
  end
end
