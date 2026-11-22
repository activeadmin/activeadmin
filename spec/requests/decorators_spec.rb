# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Decorators", type: :request do
  let!(:post) { Post.create!(title: "A very unique post", starred: false) }

  before do
    User.create!(first_name: "John", last_name: "Doe", username: "johndoe")
  end

  it "index page with decorator" do
    register_resources do
      ActiveAdmin.register Post do
        decorate_with PostDecorator

        index do
          column(:id)
          column(:title)
          column(:decorator_method)
          column(:starred)
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_text("A method only available on the decorator")
    expect(response_html).to have_text("A very unique post")
    expect(response_html).to have_css("td[data-column=starred]", exact_text: "No", normalize_ws: true)
  end

  it "index page with PORO decorator" do
    register_resources do
      ActiveAdmin.register Post do
        decorate_with PostPoroDecorator

        index do
          column(:id)
          column(:title)
          column(:decorator_method)
          column(:starred)
        end
      end
    end

    get admin_posts_path

    expect(response_html).to have_text("A method only available on the PORO decorator")
    expect(response_html).to have_text("A very unique post")
    expect(response_html).to have_css("td[data-column=starred]", exact_text: "No", normalize_ws: true)
  end

  it "show page with decorator" do
    register_resources do
      ActiveAdmin.register Post do
        decorate_with PostDecorator

        show do
          attributes_table_for(resource, :title, :decorator_method)
        end
      end
    end

    get admin_posts_path
    view_link = response_html.find_link("View", exact: true)
    expect(view_link[:href]).to eq(admin_post_path(post))
    get view_link[:href]

    expect(response_html).to have_attributes_table_text("Decorator Method", "A method only available on the decorator")
    expect(response_html).to have_attributes_table_text("Title", "A very unique post")
  end
end
