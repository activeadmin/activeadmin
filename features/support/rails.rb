require "cucumber/rails/application"
require "cucumber/rails/action_dispatch"
require "cucumber/rails/world"
require "cucumber/rails/hooks"
require "cucumber/rails/capybara"
require "cucumber/rails/database/strategy"
require "cucumber/rails/database/deletion_strategy"
require "cucumber/rails/database/shared_connection_strategy"
require "cucumber/rails/database/truncation_strategy"
require "cucumber/rails/database"

MultiTest.disable_autorun
