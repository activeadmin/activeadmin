require 'spec_helper_without_rails'
require 'support/fake_app'

# @see https://github.com/svenfuchs/rails-i18n/blob/master/spec/integration/backend_reload_spec.rb
describe "I18n backend reloading" do
  let(:app) do
    ActiveAdmin::Spec::FakeApp
  end

  context "when called twice" do
    let(:errors) do
      app.run(lambda do
        $stderr = StringIO.new
        2.times do
          I18n.reload!
          I18n.t :hello
        end
        $stderr.string
      end)
    end

    it "doesn't produce warnings" do
      errors.should == ''
    end
  end
end