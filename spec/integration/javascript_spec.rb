require 'spec_helper'
require 'jslint'

describe "Javascript" do
  
  before do
    @lint = JSLint::Lint.new(
      :config_path => 'spec/support/jslint.yml'
    )
  end
  
  it "should not have any syntax errors" do
    @lint.run
  end
end
