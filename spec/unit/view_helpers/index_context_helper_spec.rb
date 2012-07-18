require 'spec_helper'

describe IndexContextHelper, '#index_context_sentence' do

  let(:context_sentence) { IndexContextHelper::ContextSentence.new(view) }

  let(:view) do
    mock(:view, 
         :active_admin_application => active_admin_application, 
         :active_admin_config => active_admin_config,
         :assigns => {:search => search})
  end

  let(:active_admin_application) { ActiveAdmin::Application.new }
  let(:active_admin_config) do
    ns = ActiveAdmin::Namespace.new(active_admin_application, :admin)
    ActiveAdmin::Resource.new(ns, Post)
  end

  let(:search) { mock(:search_attributes => []) }

  subject { context_sentence.to_sentence }

  context "when no search" do
    it { should == 'All Posts.' }
  end

  context "when search for a title" do
    before do
      search.stub!(:search_attributes) { {"title_equals" => "Hello"} }
    end
    it { should == 'All Posts with Title "Hello".' }
  end

  context "when search for many names" do
    before do
      search.stub!(:search_attributes) do
        { "name_in" => ["Greg", "Philippe"]}
      end
    end
    it { should == 'All Posts with Name "Greg, Philippe".' }
  end

  context "when search for an association" do
    let(:user) { User.create!(:username => "pcreux") }

    before do
      search.stub!(:search_attributes) do
        { "author_id_equals" => user.id }
      end
    end
    it { should == %{All Posts with Author "pcreux".} }
  end

  context "when search for a title and an association" do
    let(:user) { User.create!(:username => "pcreux") }

    before do
      search.stub!(:search_attributes) do
        { 
          "author_id_equals" => user.id,
          "title_equals" => "Hello"
        }
      end
    end

    it { should == 'All Posts with Author "pcreux" and Title "Hello".' }
  end
end

