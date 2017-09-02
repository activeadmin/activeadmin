require 'rails_helper'
require 'active_admin/menu_item'
require 'active_admin/views/components/menu_item'

RSpec.describe ActiveAdmin::Views::MenuItem do
  let(:item) do
    i = ActiveAdmin::MenuItem.new(label: "Dashboard")
    i.add label: "Blog"
    i.add label: "Cars"
    i.add label: "Users", priority: 1
    i.add label: "Settings", priority: 2
    i.add label: "Analytics", priority: 44
    i
  end

  let(:arbe_menu_item) do
    render_arbre_component(item: item) do
      menu_item(item)
    end
  end

  let(:html) { Capybara.string(arbe_menu_item.to_s) }

  it "sorts the child items" do
    ids = html.all('li').map { |i| i[:id] }
    expect(ids).to eq %w(dashboard users settings blog cars analytics)
  end
end
