# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Index overriding", type: :controller do
  before do
    load_resources { ActiveAdmin.register Post }
    @controller = Admin::PostsController.new
  end

  context "with the call super" do
    before do
      @controller.instance_eval do
        def index
          super do |format|
            format.html { render body: "Rendered from passed block" }
          end
        end
      end
    end

    it "should call block passed to overridden index" do
      get :index
      expect(response.body).to eq "Rendered from passed block"
    end

    it "can CSV responses" do
      get :index, format: :csv
      expect(response.header["Content-Type"]).to eq "text/csv; charset=utf-8"
    end
  end

  context "with the call alias method" do
    before do
      @controller.instance_eval do
        def index
          index! do
            # Do nothing
          end
        end
      end
    end

    it "can CSV responses" do
      get :index, format: :csv
      expect(response.header["Content-Type"]).to eq "text/csv; charset=utf-8"
    end
  end
end
