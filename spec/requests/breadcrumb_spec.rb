# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Breadcrumb", type: :request do
  def custom_breadcrumb
    proc { [link_to("test", "/admin/test/url")] }
  end

  it "links to the resource index by default" do
    register_resources { ActiveAdmin.register(Post) }

    get new_admin_post_path

    expect(response_html).to have_breadcrumb_link("Posts", href: admin_posts_path)
  end

  it "uses links from a breadcrumb block" do
    links = custom_breadcrumb
    register_resources { ActiveAdmin.register(Post) { breadcrumb(&links) } }

    get new_admin_post_path

    expect(response_html).to have_breadcrumb_link("test", href: "/admin/test/url")
    expect(response_html).to have_no_css("nav[aria-label=breadcrumb] a", text: "Posts")
  end

  context "when the application disables breadcrumbs" do
    before { set_application_setting(:breadcrumb, false) }

    it "shows none" do
      register_resources { ActiveAdmin.register(Post) }

      get new_admin_post_path

      expect(response_html).to have_page_title("New Post")
      expect(response_html).to have_no_css("nav[aria-label=breadcrumb]")
    end

    it "shows them for a resource that enables them" do
      register_resources { ActiveAdmin.register(Post) { config.breadcrumb = true } }

      get new_admin_post_path

      expect(response_html).to have_breadcrumb_link("Posts", href: admin_posts_path)
    end

    it "shows links from a resource's breadcrumb block" do
      links = custom_breadcrumb
      register_resources { ActiveAdmin.register(Post) { breadcrumb(&links) } }

      get new_admin_post_path

      expect(response_html).to have_breadcrumb_link("test", href: "/admin/test/url")
    end
  end

  it "shows none for a resource that disables them" do
    set_application_setting(:breadcrumb, true)
    register_resources { ActiveAdmin.register(Post) { config.breadcrumb = false } }

    get new_admin_post_path

    expect(response_html).to have_page_title("New Post")
    expect(response_html).to have_no_css("nav[aria-label=breadcrumb]")
  end
end
