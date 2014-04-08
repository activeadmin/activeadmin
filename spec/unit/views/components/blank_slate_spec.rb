require 'spec_helper'

describe ActiveAdmin::Views::BlankSlate do

  describe "#blank_slate" do
    subject do
      render_arbre_component do
        blank_slate("There are no Posts yet. <a href=\"/posts/new\">Create one</a></span>")
      end
    end

    describe '#tag_name' do
      subject { super().tag_name }
      it    { should eql 'div' }
    end

    describe '#class_list' do
      subject { super().class_list }
      it  { should include('blank_slate_container') }
    end

    describe '#content' do
      subject { super().content }
      it     { should include '<span class="blank_slate">There are no Posts yet. <a href="/posts/new">Create one</a></span>' }
    end
  end
end
