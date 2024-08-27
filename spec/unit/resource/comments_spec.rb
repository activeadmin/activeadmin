# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ActiveAdmin Comments", type: :controller do
  before do
    load_resources { ActiveAdmin.register ActiveAdmin::Comment, as: "Comment" }
    @controller = Admin::CommentsController.new
  end

  describe "#destroy" do
    let(:user) { User.create! }
    let(:comment) { ActiveAdmin::Comment.create!(body: "body", namespace: :admin, resource: user, author: user) }

    context "success" do
      it "deletes comments and redirects to root fallback" do
        delete :destroy, params: { id: comment.id }

        expect(response).to redirect_to admin_root_url
      end

      it "deletes comments and redirects back" do
        request.env["HTTP_REFERER"] = "/admin/users/1"

        delete :destroy, params: { id: comment.id }

        expect(response).to redirect_to "/admin/users/1"
      end
    end

    context "failure" do
      it "does not delete comment on error and redirects to root fallback" do
        expect(@controller).to receive(:destroy_resource) do |comment|
          comment.errors.add(:body, :invalid)
        end

        delete :destroy, params: { id: comment.id }

        expect(response).to redirect_to admin_root_url
      end

      it "does not delete comment on error and redirects back" do
        request.env["HTTP_REFERER"] = "/admin/users/1"
        expect(@controller).to receive(:destroy_resource) do |comment|
          comment.errors.add(:body, :invalid)
        end

        delete :destroy, params: { id: comment.id }

        expect(response).to redirect_to "/admin/users/1"
      end
    end
  end
end
