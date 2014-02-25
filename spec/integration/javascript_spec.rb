require 'spec_helper'
require 'jslint'

%x[which java]
if $? == 0 # Only run the JS Lint test if Java is installed
  describe "Javascript" do
    before do
      @lint = JSLint::Lint.new(
        paths: ['public/javascripts/**/*.js'],
        exclude_paths: ['public/javascripts/vendor/**/*.js'],
        config_path: 'spec/support/jslint.yml'
      )
    end

    it "should not have any syntax errors" do
      @lint.run
    end
  end
end

