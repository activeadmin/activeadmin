# frozen_string_literal: true
require_relative "../../spec/support/simplecov_helper"

ActiveAdmin::TestSupport::SimpleCovHelper.start(["regular features", ENV["TEST_ENV_NUMBER"]].join(" ").rstrip)

require_relative "env"
