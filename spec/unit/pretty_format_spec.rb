require 'spec_helper'

describe "#pretty_format" do
  include ActiveAdmin::ViewHelpers::DisplayHelper

  context "when a String is passed in" do
    it "should return the String passed in" do
      expect(pretty_format("hello")).to eq "hello"
    end
  end

  context "when a Date or a Time is passed in" do
    it "should return a localized Date or Time with long format" do
      t = Time.now
      expect(self).to receive(:localize).with(t, {:format => :long}) { "Just Now!" }
      expect(pretty_format(t)).to eq "Just Now!"
    end

    context "actually do the formatting" do
      it "should actually do the formatting" do
        t = Time.utc(1985,"feb",28,20,15,1)
        expect(pretty_format(t)).to eq "February 28, 1985 20:15"
      end

      context "with non-English locale" do
        before(:all) do
          @previous_locale = I18n.locale.to_s
          I18n.locale = "es"
        end
        after(:all) do
          I18n.locale = @previous_locale
        end
        it "should return a localized Date or Time with long format for non-english locale" do
          t = Time.utc(1985,"feb",28,20,15,1)
          expect(pretty_format(t)).to eq "28 de febrero de 1985 20:15"
        end
      end
    end
  end

  context "when an ActiveRecord object is passed in" do
    it "should delegate to auto_link" do
      post = Post.new
      expect(self).to receive(:auto_link).with(post) { "model name" }
      expect(pretty_format(post)).to eq "model name"
    end
  end

  context "when something else is passed in" do
    it "should delegate to display_name" do
      something = Class.new.new
      expect(self).to receive(:display_name).with(something) { "I'm not famous" }
      expect(pretty_format(something)).to eq "I'm not famous"
    end
  end
end
