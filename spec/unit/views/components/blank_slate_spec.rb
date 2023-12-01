# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Views::BlankSlate do
  describe "#blank_slate" do
    subject do
      render_arbre_component do
        blank_slate do
          text_node "There are no Posts yet."
          a "Create one", href: "/posts/new"
        end
      end
    end

    describe "#tag_name" do
      subject { super().tag_name }
      it { is_expected.to eql "div" }
    end

    describe "#class_list" do
      subject { super().class_list }
      it { is_expected.to include("blank-slate") }
    end

    describe "#content" do
      subject { super().content }
      it { is_expected.to include 'There are no Posts yet.  <a href="/posts/new">Create one</a>' }
    end
  end
end
