require 'rails_helper'

describe ActiveAdmin::Views::SidebarSection do

  let(:options) { {} }

  let(:section) do
    ActiveAdmin::SidebarSection.new("Help Section", options) do
      span "Help Me"
    end
  end

  let(:html) do
    result = render_arbre_component section: section do
      sidebar_section(assigns[:section])
    end
    Capybara.string(result.to_s)
  end

  it "should have a title h3" do
    expect(html).to have_css '.panel-title', text: 'Help Section'
  end

  it "should have the class of 'sidebar_section'" do
    expect(html).to have_css ".sidebar_section"
  end

  it "should have an id based on the title" do
    expect(html).to have_css "#help-section_sidebar_section"
  end

  it "should have a panel body" do
    expect(html).to have_css '.panel-body'
  end

  it "should add children to the panel body" do
    expect(html).to have_css '.panel-body > span'
  end

  context 'with a custom class attribute' do
    let(:options) { { class: 'custom_class' } }

    it "should have 'custom_class' class" do
      expect(html).to have_css ".custom_class"
    end
  end

end
