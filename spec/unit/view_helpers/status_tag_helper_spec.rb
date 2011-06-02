require 'spec_helper'

describe ActiveAdmin::ViewHelpers::StatusTagHelper do
  include Arbre::HTML
  let(:assigns) { {} }

  let(:helpers) { action_view }

  describe "#status_tag" do
    context "when status is 'Completed'" do
      subject { status_tag('Completed') }

      it { should == %{<span class="status completed">Completed</span>} }
      it { should == %{<span class="status completed">Completed</span>} }
    end

    context "when status is 'Active' and class is 'ok'" do
      subject { status_tag('Active', :class => 'ok') }

      it { should == %{<span class="status active ok">Active</span>} }
    end

    context "when status is nil" do
      subject { status_tag(nil) }

      it { should == %{<span class="status"></span>} }
    end
  end # describe "#status_tag"
end
