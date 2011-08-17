require 'spec_helper'

describe ActiveAdmin::Views::BlankSlate do

  setup_arbre_context!

  describe "#blank_slate" do
    subject { blank_slate("There are no Posts yet. <a href=\"/posts/new\">Create one</a></span>") }

    its(:tag_name)    { should eql 'div' }
    its(:class_list)  { should include('blank_slate_container') }

    its(:content)     { should include '<span class="blank_slate">There are no Posts yet. <a href="/posts/new">Create one</a></span>' }
  end
end
