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


    describe '#tag_name' do
      subject { super().tag_name }
      it    { should eq 'span' }
    end

    describe '#class_list' do
      subject { super().class_list }
      it  { should include('status_tag') }
    end

    context "when status is 'completed'" do
      subject { status_tag('completed') }

      describe '#tag_name' do
        subject { super().tag_name }
        it    { should eq 'span' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('completed') }
      end

      describe '#content' do
        subject { super().content }
        it     { should eq 'Completed' }
      end
    end

    context "when status is 'in_progress'" do
      subject { status_tag('in_progress') }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('in_progress') }
      end

      describe '#content' do
        subject { super().content }
        it     { should eq 'In Progress' }
      end
    end

    context "when status is 'In progress'" do
      subject { status_tag('In progress') }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('in_progress') }
      end

      describe '#content' do
        subject { super().content }
        it     { should eq 'In Progress' }
      end
    end

    context "when status is an empty string" do
      subject { status_tag('') }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it     { should eq '' }
      end
    end

    context "when status is false" do
      subject { status_tag('false') }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it     { should == 'No' }
      end
    end

    context "when status is nil" do
      subject { status_tag(nil) }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#content' do
        subject { super().content }
        it     { should == 'No' }
      end
    end

    context "when status is 'Active' and type is :ok" do
      subject { status_tag('Active', :ok) }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('active') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('ok') }
      end
    end

    context "when status is 'Active' and class is 'ok'" do
      subject { status_tag('Active', class: 'ok') }

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('active') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('ok') }
      end
    end

    context "when status is 'Active' and label is 'on'" do
      subject { status_tag('Active', label: 'on') }

      describe '#content' do
        subject { super().content }
        it     { should eq 'on' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('active') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should_not include('on') }
      end
    end

    context "when status is 'So useless', type is :ok, class is 'woot awesome' and id is 'useless'" do
      subject { status_tag('So useless', :ok, class: 'woot awesome', id: 'useless') }

      describe '#content' do
        subject { super().content }
        it     { should eq 'So Useless' }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('status_tag') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('ok') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('so_useless') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('woot') }
      end

      describe '#class_list' do
        subject { super().class_list }
        it  { should include('awesome') }
      end

      describe '#id' do
        subject { super().id }
        it          { should eq 'useless' }
      end
    end

  end # describe "#status_tag"
end
