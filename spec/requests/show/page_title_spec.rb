# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Show page title", type: :request do
  let(:author) { User.create!(first_name: "Jane", last_name: "Doe", username: "janedoe") }
  let(:post) { Post.create!(title: "Hello World", author: author) }
  let(:tag) { Tag.create! }

  it "uses a method to be called on the resource as the title" do
    register_resources do
      ActiveAdmin.register Post do
        show title: :title
      end
    end

    get admin_post_path(post)

    expect(response_html).to have_page_title("Hello World")
  end

  it "uses a string as the title" do
    register_resources do
      ActiveAdmin.register Post do
        show title: "Title From String"
      end
    end

    get admin_post_path(post)

    expect(response_html).to have_page_title("Title From String")
  end

  it "uses a proc as the title" do
    register_resources do
      ActiveAdmin.register Post do
        show title: proc { |post| "Title: " + post.title }
      end
    end

    get admin_post_path(post)

    expect(response_html).to have_page_title("Title: Hello World")
  end

  it "uses the display name by default" do
    register_resources do
      ActiveAdmin.register Post
    end

    get admin_post_path(post)

    expect(response_html).to have_page_title("Hello World")
  end

  it "includes the ID when no display name method exists" do
    register_resources do
      ActiveAdmin.register Tag
    end

    get admin_tag_path(tag)

    expect(response_html).to have_page_title("Tag ##{tag.id}")
  end

  it "uses the title in controller" do
    register_resources do
      ActiveAdmin.register Post do
        controller do
          before_action { @page_title = "List of #{resource_class.model_name.plural}" }
        end
      end
    end

    get admin_post_path(post)

    expect(response_html).to have_page_title("List of posts")
  end
end
