require 'rails_helper'

RSpec.describe ActiveAdmin::Views::Sidebar do
  let(:section) do
    ActiveAdmin::SidebarSection.new("Section") do
      para 'Section content.'
    end
  end

  let(:html) do
    render_arbre_component sections: [section] do
      sidebar assigns[:sections], id: 'sidebar'
    end
  end

  it "should have an id of 'sidebar'" do
    expect(html.id).to eq 'sidebar'
  end

  it "renders the section" do
    expect(html.find_by_tag('p').first.content).to eq 'Section content.'
  end
end
