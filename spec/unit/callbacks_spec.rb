# frozen_string_literal: true
require "rails_helper"

RSpec.describe ActiveAdmin::Callbacks do
  it "rejects callbacks registered with a string instead of a symbol or block" do
    model = Class.new do
      include ActiveAdmin::Callbacks

      define_active_admin_callbacks :save
      before_save "validate_record"

      def save
        run_save_callbacks {}
      end
    end

    expect do
      model.new.save
    end.to raise_error(RuntimeError, "Please register with callbacks using a symbol or a block/proc.")
  end
end
