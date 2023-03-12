# frozen_string_literal: true
require "open3"

RSpec.describe "local task" do
  let(:local) do
    Open3.capture2e("bin/rake local runner 'AdminUser.first'")
  end

  it "succeeds" do
    expect(local[1]).to be_success, local[0]
  end
end
