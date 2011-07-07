require 'spec_helper'

describe ActiveAdmin::Views::BlankSlate do
  include Arbre::HTML
  
  let(:assigns){ {} }

  let(:helpers) { action_view }
  
  describe "#blank_slate" do
    subject { blank_slate("Posts", "/posts/new") }
    
    its(:tag_name)    { should eql 'div' }
    its(:class_list)  { should include('blank_slate_container') }
    
    describe "content" do
      subject { blank_slate("Posts", "/posts/new").content }

      context "when url passed in" do
        it { should include '<span class="blank_slate">There are no Posts yet. <a href="/posts/new">Create one</a></span>' }
      end
      
      context "when no url passed in" do
        subject { blank_slate("Posts").content }
        
        it { should include '<span class="blank_slate">There are no Posts yet.</span>' }
      end
    end

  end
end