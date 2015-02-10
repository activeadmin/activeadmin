require 'rails_helper'

describe ActiveAdmin::Views::SiteTitle do

  let(:helpers){ mock_action_view }

  def build_title(namespace)
    render_arbre_component({namespace: namespace}, helpers) do
      insert_tag ActiveAdmin::Views::SiteTitle, assigns[:namespace]
    end
  end

  context "when a value" do

    it "renders the string when a string is passed in" do
      namespace = double site_title: "Hello World",
                         site_title_image: nil,
                         site_title_link: nil

      site_title = build_title(namespace)
      expect(site_title.content).to eq "Hello World"
    end

    it "renders the return value of a method when a symbol" do
      expect(helpers).to receive(:hello_world).and_return("Hello World")

      namespace = double site_title: :hello_world,
                         site_title_image: nil,
                         site_title_link: nil

      site_title = build_title(namespace)
      expect(site_title.content).to eq "Hello World"
    end

    it "renders the return value of a proc" do
      namespace = double site_title: proc{ "Hello World" },
                         site_title_image: nil,
                         site_title_link: nil

      site_title = build_title(namespace)
      expect(site_title.content).to eq "Hello World"
    end

  end

  context "when an image" do

    it "renders the string when a string is passed in" do
      expect(helpers).to receive(:image_tag).
        with("an/image.png", alt: nil, id: "site_title_image").
        and_return '<img src="/assets/an/image.png" />'.html_safe

      namespace = double site_title: nil,
                         site_title_image: "an/image.png",
                         site_title_link: nil

      site_title = build_title(namespace)
      expect(site_title.content.strip).to eq '<img src="/assets/an/image.png" />'
    end

  end

  context "when a link is present" do

    it "renders the string when a string is passed in" do
      namespace = double site_title: "Hello World",
                         site_title_image: nil,
                         site_title_link: "/"

      site_title = build_title(namespace)
      expect(site_title.content).to eq '<a href="/">Hello World</a>'
    end

  end



end
