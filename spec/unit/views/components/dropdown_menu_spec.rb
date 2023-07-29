# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::DropdownMenu do
  describe "Rendering DropdownMenu" do
    let(:dropdown) do
      render_arbre_component do
        dropdown_menu "Administration" do
          item "Edit Details", "/details"
          item do
            span "Some Content"
          end
        end
      end
    end

    it "should render an item as a link" do
      expect(dropdown.to_s.squish).to include('<li><a href="/details">Edit Details</a></li>')
    end

    it "should render any content when an item has a block" do
      expect(dropdown.to_s.squish).to include('<li> <span>Some Content</span> </li>')
    end
  end
end
