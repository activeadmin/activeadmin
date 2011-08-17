require 'spec_helper'

describe Arbre::HTML::Element do

  setup_arbre_context!

  let(:element){ Arbre::HTML::Element.new }

  context "when initialized" do
    it "should have no children" do
      element.children.should be_empty
    end
    it "should have no parent" do
      element.parent.should be_nil
    end
    it "should have no document" do
      element.document.should be_nil
    end
    it "should respond to the HTML builder methods" do
      element.should respond_to(:span)
    end
    it "should have a set of local assigns" do
      element = Arbre::HTML::Element.new :hello => "World"
      element.assigns[:hello].should == "World"
    end
    it "should have an empty hash with no local assigns" do
      element.assigns.should == {}
    end
  end

  describe "passing in a helper object" do
    let(:element){ Arbre::HTML::Element.new(nil, action_view) }
    it "should call methods on the helper object and return TextNode objects" do
      element.content_tag(:div).should == "<div></div>"
    end

    it "should raise a NoMethodError if not found" do
      lambda {
        element.a_method_that_doesnt_exist
      }.should raise_error(NoMethodError)
    end
  end

  describe "passing in assigns" do
    let(:assigns){ {:post => Post.new(:title => "Hello")} }
    it "should be accessible via a method call" do
      post.should be_an_instance_of(Post)
    end
  end

  describe "adding a child" do
    let(:child){ Arbre::HTML::Element.new }
    before do
      element.add_child child
    end

    it "should add the child to the parent" do
      element.children.first.should == child
    end

    it "should set the parent of the child" do
      child.parent.should == element
    end

    context "when the child is nil" do
      let(:child){ nil }
      it "should not add the child" do
        element.children.should be_empty
      end
    end

    context "when the child is a string" do
      let(:child){ "Hello World" }
      it "should add as a TextNode" do
        element.children.first.should be_instance_of(Arbre::HTML::TextNode)
        element.children.first.to_html.should == "Hello World"
      end
    end
  end

  describe "setting the content" do

    context "when a string" do
      before do
        element.add_child "Hello World"
        element.content = "Goodbye"
      end
      it "should clear the existing children" do
        element.children.size.should == 1
      end

      it "should add the string as a child" do
        element.children.first.to_html.should == "Goodbye"
      end

      it "should html escape the string" do
        string = "Goodbye <br />"
        element.content = string
        element.content.to_html.should == "Goodbye &lt;br /&gt;"
      end
    end

    context "when a tag" do
      before do
        element.content = h2("Hello")
      end
      it "should set the content tag" do
        element.children.first.should be_an_instance_of(Arbre::HTML::H2)
      end
      it "should set the tags parent" do
        element.children.first.parent.should == element
      end
    end

    context "when an array of tags" do
      before do
        element.content = [ul,div]
      end

      it "should set the content tag" do
        element.children.first.should be_an_instance_of(Arbre::HTML::Ul)
      end
      it "should set the tags parent" do
        element.children.first.parent.should == element
      end
    end

  end

  describe "setting the parent" do
    let(:parent) do
      doc = Arbre::HTML::Document.new
      parent = Arbre::HTML::Element.new
      doc << parent
      parent
    end
    before { element.parent = parent }

    it "should set the parent" do
      element.parent.should == parent
    end
    it "should set the document to the parent's document" do
      element.document.should == parent.document
    end
  end

  describe "rendering to html" do
    it "should render the children collection" do
      element.children.should_receive(:to_html).and_return("content")
      element.to_html.should == "content"
    end
  end

  describe "adding elements together" do

    context "when both elements are tags" do
      let(:collection){ h1 + h2}

      it "should return an instance of Collection" do
        collection.should be_an_instance_of(Arbre::HTML::Collection)
      end

      it "should return the elements in the collection" do
        collection.size.should == 2
        collection.first.should be_an_instance_of(Arbre::HTML::H1)
        collection[1].should be_an_instance_of(Arbre::HTML::H2)
      end
    end

    context "when the left is a collection and the right is a tag" do
      let(:collection){ Arbre::HTML::Collection.new([h1, h2]) + h3}

      it "should return an instance of Collection" do
        collection.should be_an_instance_of(Arbre::HTML::Collection)
      end

      it "should return the elements in the collection flattened" do
        collection.size.should == 3
        collection[0].should be_an_instance_of(Arbre::HTML::H1)
        collection[1].should be_an_instance_of(Arbre::HTML::H2)
        collection[2].should be_an_instance_of(Arbre::HTML::H3)
      end
    end

    context "when the right is a collection and the left is a tag" do
      let(:collection){ h1 + Arbre::HTML::Collection.new([h2,h3]) }

      it "should return an instance of Collection" do
        collection.should be_an_instance_of(Arbre::HTML::Collection)
      end

      it "should return the elements in the collection flattened" do
        collection.size.should == 3
        collection[0].should be_an_instance_of(Arbre::HTML::H1)
        collection[1].should be_an_instance_of(Arbre::HTML::H2)
        collection[2].should be_an_instance_of(Arbre::HTML::H3)
      end
    end

    context "when the left is a tag and the right is a string" do
      let(:collection){ h1 + "Hello World"}

      it "should return an instance of Collection" do
        collection.should be_an_instance_of(Arbre::HTML::Collection)
      end

      it "should return the elements in the collection" do
        collection.size.should == 2
        collection[0].should be_an_instance_of(Arbre::HTML::H1)
        collection[1].should be_an_instance_of(Arbre::HTML::TextNode)
      end
    end

    context "when the left is a string and the right is a tag" do
      let(:collection){ "hello World" + h1}

      it "should return a string" do
        collection.strip.chomp.should == "hello World<h1></h1>"
      end
    end
  end

end
