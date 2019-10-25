require "open3"

RSpec.describe "JS bundle sanity" do
  it "is up to date" do
    current_bundle = File.read("app/assets/javascripts/active_admin/base.js")

    output, status = Open3.capture2e("yarn build -o tmp/bundle.js")
    expect(status).to be_success, output

    new_bundle = File.read("tmp/bundle.js")

    msg = "Javascript bundle is out of date. Please run `yarn build` and commit changes."

    expect(current_bundle).to eq(new_bundle), msg
  end
end
