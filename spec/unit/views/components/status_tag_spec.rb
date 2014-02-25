require 'spec_helper'

describe ActiveAdmin::Views::StatusTag do

  describe "#status_tag" do

    # Helper method to build StatusTag objects in an Arbre context
    def status_tag(*args)
      render_arbre_component(status_tag_args: args) do
        status_tag(*assigns[:status_tag_args])
      end
    end

    subject { status_tag(nil) }


    its(:tag_name)    { should eq 'span' }
    its(:class_list)  { should include('status_tag') }

    context "when status is 'completed'" do
      subject { status_tag('completed') }

      its(:tag_name)    { should eq 'span' }
      its(:class_list)  { should include('status_tag') }
      its(:class_list)  { should include('completed') }
      its(:content)     { should eq 'Completed' }
    end

    context "when status is 'in_progress'" do
      subject { status_tag('in_progress') }

      its(:class_list)  { should include('in_progress') }
      its(:content)     { should eq 'In Progress' }
    end

    context "when status is 'In progress'" do
      subject { status_tag('In progress') }

      its(:class_list)  { should include('in_progress') }
      its(:content)     { should eq 'In Progress' }
    end

    context "when status is an empty string" do
      subject { status_tag('') }

      its(:class_list)  { should include('status_tag') }
      its(:content)     { should eq '' }
    end
    
    context "when status is false" do
      subject { status_tag('false') }

      its(:class_list)  { should include('status_tag') }
      its(:content)     { should == 'No' }
    end

    context "when status is nil" do
      subject { status_tag(nil) }

      its(:class_list)  { should include('status_tag') }
      its(:content)     { should == 'No' }
    end

    context "when status is 'Active' and type is :ok" do
      subject { status_tag('Active', :ok) }

      its(:class_list)  { should include('status_tag') }
      its(:class_list)  { should include('active') }
      its(:class_list)  { should include('ok') }
    end

    context "when status is 'Active' and class is 'ok'" do
      subject { status_tag('Active', class: 'ok') }

      its(:class_list)  { should include('status_tag') }
      its(:class_list)  { should include('active') }
      its(:class_list)  { should include('ok') }
    end

    context "when status is 'Active' and label is 'on'" do
      subject { status_tag('Active', label: 'on') }

      its(:content)     { should eq 'on' }
      its(:class_list)  { should include('status_tag') }
      its(:class_list)  { should include('active') }
      its(:class_list)  { should_not include('on') }
    end

    context "when status is 'So useless', type is :ok, class is 'woot awesome' and id is 'useless'" do
      subject { status_tag('So useless', :ok, class: 'woot awesome', id: 'useless') }

      its(:content)     { should eq 'So Useless' }
      its(:class_list)  { should include('status_tag') }
      its(:class_list)  { should include('ok') }
      its(:class_list)  { should include('so_useless') }
      its(:class_list)  { should include('woot') }
      its(:class_list)  { should include('awesome') }
      its(:id)          { should eq 'useless' }
    end

  end # describe "#status_tag"
end
