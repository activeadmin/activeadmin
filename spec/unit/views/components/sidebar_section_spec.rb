require 'rails_helper'

RSpec.describe ActiveAdmin::Views::SidebarSection do

  let(:options) { {} }

  let(:section) do
    ActiveAdmin::SidebarSection.new("Help Section", options) do
      span "Help Me"
    end
  end

  let(:html) do
    render_arbre_component section: section do
      sidebar_section(assigns[:section])
    end
  end

  it "should have a title h3" do
    expect(html.find_by_tag("h3").first.content).to eq "Help Section"
  end

  it "should have the class of 'sidebar_section'" do
    expect(html.class_list).to include("sidebar_section")
  end

  it "should have an id based on the title" do
    expect(html.id).to eq "help-section_sidebar_section"
  end

  it "should have a contents div" do
    expect(html.find_by_tag("div").first.class_list).to include("panel_contents")
  end

  it "should add children to the contents div" do
    expect(html.find_by_tag("span").first.parent).to eq html.find_by_tag("div").first
  end

  context 'with a custom class attribute' do
    let(:options) { { class: 'custom_class' } }

    it "should have 'custom_class' class" do
      expect(html.class_list).to include("custom_class")
    end
  end

  context "with attributes_table for resource" do
    let(:post) { Post.create!(title: "Testing.") }
    let(:section) do
      ActiveAdmin::SidebarSection.new("Summary", options) do
        attributes_table do
          row :title
        end
      end
    end
    let(:assigns) { { resource: post, section: section } }
    let(:html) do
      render_arbre_component assigns do
        sidebar_section(assigns[:section])
      end
    end

    it "should have table" do
      expect(html.find_by_tag("th").first.content).to eq "Title"
      expect(html.find_by_tag("td").first.content).to eq "Testing."
    end
  end
end
