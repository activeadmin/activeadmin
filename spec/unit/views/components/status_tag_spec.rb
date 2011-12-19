require 'spec_helper'

describe ActiveAdmin::Views::StatusTag do

  setup_arbre_context!

  describe "#status_tag" do
    subject { status_tag(nil) }

    its(:tag_name)    { should == 'span' }
    its(:class_list)  { should include('status') }

    context "when status is 'completed'" do
      subject { status_tag('completed') }

      its(:tag_name)    { should == 'span' }
      its(:class_list)  { should include('status') }
      its(:class_list)  { should include('completed') }
      its(:content)     { should == 'Completed' }
    end

    context "when status is 'in_progress'" do
      subject { status_tag('in_progress') }

      its(:class_list)  { should include('in_progress') }
      its(:content)     { should == 'In Progress' }
    end

    context "when status is 'In progress'" do
      subject { status_tag('In progress') }

      its(:class_list)  { should include('in_progress') }
      its(:content)     { should == 'In Progress' }
    end

    context "when status is an empty string" do
      subject { status_tag('') }

      its(:class_list)  { should include('status') }
      its(:content)     { should == '' }
    end

    context "when status is nil" do
      subject { status_tag(nil) }

      its(:class_list)  { should include('status') }
      its(:content)     { should == '' }
    end

    context "when status is 'Active' and type is :ok" do
      subject { status_tag('Active', :ok) }

      its(:class_list)  { should include('status') }
      its(:class_list)  { should include('active') }
      its(:class_list)  { should include('ok') }
    end

    context "when status is 'Active' and class is 'ok'" do
      subject { status_tag('Active', :class => 'ok') }

      its(:class_list)  { should include('status') }
      its(:class_list)  { should include('active') }
      its(:class_list)  { should include('ok') }
    end

    context "when status is 'Active' and label is 'on'" do
      subject { status_tag('Active', :label => 'on') }

      its(:content)     { should == 'on' }
      its(:class_list)  { should include('status') }
      its(:class_list)  { should include('active') }
      its(:class_list)  { should_not include('on') }
    end

    context "when status is 'So useless', type is :ok, class is 'woot awesome' and id is 'useless'" do
      subject { status_tag('So useless', :ok, :class => 'woot awesome', :id => 'useless') }

      its(:content)     { should == 'So Useless' }
      its(:class_list)  { should include('status') }
      its(:class_list)  { should include('ok') }
      its(:class_list)  { should include('so_useless') }
      its(:class_list)  { should include('woot') }
      its(:class_list)  { should include('awesome') }
      its(:id)          { should == 'useless' }
    end

  end # describe "#status_tag"
end
