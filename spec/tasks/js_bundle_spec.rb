# frozen_string_literal: true
require "open3"

RSpec.describe "JS bundle sanity" do
  it "is up to date" do
    current_umd = File.read("app/assets/javascripts/active_admin/base.js")
    current_esm = File.read("app/assets/javascripts/active_admin/base-esm.js")

    `bin/yarn install`
    output, status = Open3.capture2e("PATH_PREFIX=tmp/ bin/yarn build")
    expect(status).to be_success, output

    new_umd = File.read("tmp/app/assets/javascripts/active_admin/base.js")
    new_esm = File.read("tmp/app/assets/javascripts/active_admin/base-esm.js")

    msg = "Javascript bundle is out of date. Please run `yarn build` and commit changes."

    expect(current_umd).to eq(new_umd), msg
    expect(current_esm).to eq(new_esm), msg
  end
end
