require 'rails_helper'
require 'jslint'
require 'rbconfig'

# OSX has its own java executable that opens a prompt to install Java 💩
# However this java_home executable returns an error code without opening the prompt ✅
RbConfig::CONFIG['host_os'].include?('darwin') ? `/usr/libexec/java_home` : `which java`
java_installed = $?.success?

describe 'Javascript', type: :request, if: java_installed do
  let(:lint) {
    JSLint::Lint.new \
      paths:         ['public/javascripts/**/*.js'],
      exclude_paths: ['public/javascripts/vendor/**/*.js'],
      config_path:   'spec/support/jslint.yml'
  }

  it 'should not have any syntax errors' do
    lint.run
  end
end

