require 'spec_helper'

describe ActiveAdmin::Views::Columns do

  setup_arbre_context!

  describe "Rendering one column" do
    let(:cols) do
      columns do
        column { span "Hello World" }
      end
    end

    it "should have the class .columns" do
      cols.class_list.should include("columns")
    end

    it "should have one column" do
      cols.children.size.should == 1
      cols.children.first.class_list.should include("column")
    end

    it "should have one column with the width 100%" do
      cols.children.first.attr(:style).should include("width: 100%")
    end
  end

  describe "Rendering two columns" do
    let(:cols) do
      columns do
        column { span "Hello World" }
        column { span "Hello World" }
      end
    end

    it "should have two columns" do
      cols.children.size.should == 2
    end

    it "should have a first column with width 49% and margin 2%" do
      cols.children.first.attr(:style).should == "width: 49%; margin-right: 2%;"
    end

    it "should have a second column with width 49% and no right margin" do
      cols.children.last.attr(:style).should == "width: 49%;"
    end
  end

  describe "Rendering four columns" do
    let(:cols) do
      columns do
        column { span "Hello World" }
        column { span "Hello World" }
        column { span "Hello World" }
        column { span "Hello World" }
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

end
