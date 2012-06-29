require 'spec_helper'

describe ActiveAdmin::Views::Columns do

  describe "Rendering one column" do
    let(:cols) do
      render_arbre_component do
        columns do
          column { span "Hello World" }
        end
      end
    end

    it "should have the class .columns" do
      cols.class_list.should include("columns")
    end

    it "should have one column" do
      cols.children.size.should == 1
      cols.children.first.class_list.should include("column")
    end

    it "should have one column with the width 100.0%" do
      cols.children.first.attr(:style).should include("width: 100.0%")
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
      cols.children.size.should == 2
    end

    it "should have a first column with width 49% and margin 2%" do
      cols.children.first.attr(:style).should == "width: 49.0%; margin-right: 2%;"
    end

    it "should have a second column with width 49% and no right margin" do
      cols.children.last.attr(:style).should == "width: 49.0%;"
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
      cols.children.size.should == 4
    end


    (0..2).to_a.each do |index|
      it "should have column #{index + 1} with width 49% and margin 2%" do
        cols.children[index].attr(:style).should == "width: 23.5%; margin-right: 2%;"
      end
    end

    it "should have column 4 with width 49% and no margin" do
      cols.children[3].attr(:style).should == "width: 23.5%;"
    end
  end


  describe "Column Spans" do
    let(:cols) do
      render_arbre_component do
        columns do
          column(:span => 2){ "Hello World" }
          column(){ "Hello World" }
          column(){ "Hello World" }
        end
      end
    end

    it "should set the span when declared" do
      cols.children.first.attr(:style).should == "width: 49.0%; margin-right: 2%;"
    end

    it "should default to 1 if not passed in" do
      cols.children.last.attr(:style).should == "width: 23.5%;"
    end
  end

  describe "Column max width" do

    let(:cols) do
      render_arbre_component do
        columns do
          column(:max_width => "100px"){ "Hello World" }
          column(){ "Hello World" }
        end
      end
    end

    it "should set the max with if passed in" do
      cols.children.first.attr(:style).should == "width: 49.0%; max-width: 100px; margin-right: 2%;"
    end

    it "should omit the value if not presetn" do
      cols.children.last.attr(:style).should == "width: 49.0%;"
    end

  end

  describe "Column min width" do

    let(:cols) do
      render_arbre_component do
        columns do
          column(:min_width => "100px"){ "Hello World" }
          column(){ "Hello World" }
        end
      end
    end

    it "should set the min with if passed in" do
      cols.children.first.attr(:style).should == "width: 49.0%; min-width: 100px; margin-right: 2%;"
    end

    it "should omit the value if not presetn" do
      cols.children.last.attr(:style).should == "width: 49.0%;"
    end

  end

end
