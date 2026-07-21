# frozen_string_literal: true
require_relative "simplecov_helper"

ActiveAdmin::TestSupport::SimpleCovHelper.start(["regular specs", ENV["TEST_ENV_NUMBER"]].join(" ").rstrip)
