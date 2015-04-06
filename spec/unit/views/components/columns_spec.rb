require 'rails_helper'

describe ActiveAdmin::Views::Columns do

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

    it "should have one column" do
      expect(cols.children.first.class_list).not_to include("column")
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
      expect(cols.children.size).to eq 1
      expect(cols.children.first.class_list).to include("column")
    end

    it "should have one column with the width 100.0%" do
      expect(cols.children.first.attr(:style)).to include("width: 100.0%")
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

    it "should have two columns" do
      expect(cols.children.size).to eq 2
    end

    it "should have a first column with width 49% and margin 2%" do
      expect(cols.children.first.attr(:style)).to eq "width: 49.0%; margin-right: 2%;"
    end

    it "should have a second column with width 49% and no right margin" do
      expect(cols.children.last.attr(:style)).to eq "width: 49.0%;"
    end
  end

  describe "Rendering four columns" do
    let(:cols) do
      render_arbre_component do
        columns do
          column { span "Hello World" }
          column { span "Hello World" }
          column { span "Hello World" }
          column { span "Hello World" }
        end
      end
    end

    it "should have four columns" do
      expect(cols.children.size).to eq 4
    end


    (0..2).to_a.each do |index|
      it "should have column #{index + 1} with width 49% and margin 2%" do
        expect(cols.children[index].attr(:style)).to eq "width: 23.5%; margin-right: 2%;"
      end
    end

    it "should have column 4 with width 49% and no margin" do
      expect(cols.children[3].attr(:style)).to eq "width: 23.5%;"
    end
  end


  describe "Column Spans" do
    let(:cols) do
      render_arbre_component do
        columns do
          column(span: 2){ "Hello World" }
          column(){ "Hello World" }
          column(){ "Hello World" }
        end
      end
    end

    it "should set the span when declared" do
      expect(cols.children.first.attr(:style)).to eq "width: 49.0%; margin-right: 2%;"
    end

    it "should default to 1 if not passed in" do
      expect(cols.children.last.attr(:style)).to eq "width: 23.5%;"
    end
  end

  describe "Column max width" do

    let(:cols) do
      render_arbre_component do
        columns do
          column(max_width: "100px"){ "Hello World" }
          column(){ "Hello World" }
        end
      end
    end

    it "should set the max with if passed in" do
      expect(cols.children.first.attr(:style)).to eq "width: 49.0%; max-width: 100px; margin-right: 2%;"
    end

    it "should omit the value if not present" do
      expect(cols.children.last.attr(:style)).to eq "width: 49.0%;"
    end

    context "when passed an integer value" do
      let(:cols) do
        render_arbre_component do
          columns do
            column(max_width: 100){ "Hello World" }
            column(){ "Hello World" }
          end
        end
      end

      it "should be treated as pixels" do
        expect(cols.children.first.attr(:style)).to eq "width: 49.0%; max-width: 100px; margin-right: 2%;"
      end
    end

  end

  describe "Column min width" do

    let(:cols) do
      render_arbre_component do
        columns do
          column(min_width: "100px"){ "Hello World" }
          column(){ "Hello World" }
        end
      end
    end

    it "should set the min with if passed in" do
      expect(cols.children.first.attr(:style)).to eq "width: 49.0%; min-width: 100px; margin-right: 2%;"
    end

    it "should omit the value if not present" do
      expect(cols.children.last.attr(:style)).to eq "width: 49.0%;"
    end

    context "when passed an integer value" do
      let(:cols) do
        render_arbre_component do
          columns do
            column(min_width: 100){ "Hello World" }
            column(){ "Hello World" }
          end
        end
      end

      it "should be treated as pixels" do
        expect(cols.children.first.attr(:style)).to eq "width: 49.0%; min-width: 100px; margin-right: 2%;"
      end
    end

  end

end
