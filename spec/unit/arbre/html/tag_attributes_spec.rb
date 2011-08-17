require 'spec_helper'

describe Arbre::HTML::Tag, "Attributes" do

  setup_arbre_context!

  let(:tag){ Arbre::HTML::Tag.new }

  describe "attributes" do
    before { tag.build :id => "my_id" }

    it "should have an attributes hash" do
      tag.attributes.should == {:id => "my_id"}
    end

    it "should render the attributes to html" do
      tag.to_html.should == <<-HTML
<tag id="my_id"></tag>
HTML
    end

    it "should get an attribute value" do
      tag.attr(:id).should == "my_id"
    end

    describe "#has_attribute?" do
      context "when the attribute exists" do
        it "should return true" do
          tag.has_attribute?(:id).should == true
        end
      end

      context "when the attribute does not exist" do
        it "should return false" do
          tag.has_attribute?(:class).should == false
        end
      end
    end

    it "should remove an attribute" do
      tag.attributes.should == {:id => "my_id"}
      tag.remove_attribute(:id).should == "my_id"
      tag.attributes.should == {}
    end
  end

  describe "rendering attributes" do
    it "should html safe the attribute values" do
      tag.set_attribute(:class, "\">bad things!")
      tag.to_html.should == <<-HTML
<tag class="&quot;&gt;bad things!"></tag>
HTML
    end
    it "should should escape the attribute names" do
      tag.set_attribute(">bad", "things")
      tag.to_html.should == <<-HTML
<tag &gt;bad="things"></tag>
HTML
    end
  end
end
