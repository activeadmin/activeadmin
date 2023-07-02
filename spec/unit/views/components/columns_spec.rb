# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::Columns do
  describe "Rendering zero columns" do
    let(:cols) do
      render_arbre_component do
        columns do
        end
      end
    end

    it "should have the class .columns" do
      expect(cols.class_list).to include("columns")
    end

    it "should not have any children" do
      expect(cols.to_s).to include('<div class="columns"></div>')
    end
  end

  describe "Rendering one column" do
    let(:cols) do
      render_arbre_component do
        columns do
          column { span "Hello World" }
        end
      end
    end

    it "should have the class .columns" do
      expect(cols.class_list).to include("columns")
    end

    it "should have one column" do
      expect(cols.to_s).to eq(<<~HTML)
        <div class="columns">
          <div>
            <span>Hello World</span>
          </div>
        </div>
      HTML
    end
  end

  describe "Rendering two columns" do
    let(:cols) do
      render_arbre_component do
        columns do
          column { span "Hello World" }
          column { span "Hello World" }
        end
      end
    end

    it "should have the class .columns" do
      expect(cols.class_list).to include("columns")
    end

    it "should have two columns" do
      expect(cols.to_s).to eq(<<~HTML)
        <div class="columns">
          <div>
            <span>Hello World</span>
          </div>
          <div>
            <span>Hello World</span>
          </div>
        </div>
      HTML
    end
  end

  describe "Setting CSS Class" do
    let(:cols) do
      render_arbre_component do
        columns class: "gap-4" do
          column { span "Hello World" }
          column { span "Hello World" }
        end
      end
    end

    it "keeps base class and appends given utility class" do
      expect(cols.to_s).to include('<div class="gap-4 columns">')
    end
  end
end
