require 'rails_helper'

describe ActiveAdmin::Views::BlankSlate do

  describe "#blank_slate" do
    subject do
      render_arbre_component do
        blank_slate("There are no Posts yet. <a href=\"/posts/new\">Create one</a>")
      end
    end

    describe '#tag_name' do
      subject { super().tag_name }
      it    { is_expected.to eql 'div' }
    end

    describe '#class_list' do
      subject { super().class_list }
      it  { is_expected.to include('blank_slate_container') }
    end

    describe '#content' do
      subject { super().content }
      it     { is_expected.to include '<div class="blank_slate">There are no Posts yet. <a href="/posts/new">Create one</a></div>' }
    end
  end
end
