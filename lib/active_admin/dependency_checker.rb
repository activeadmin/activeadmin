require 'rails/version'

module ActiveAdmin
  module DependencyChecker
    class << self
      def check!
        if pry_rails_before_0_1_6?
          warn "ActiveAdmin is not compatible with pry-rails < 0.1.6. Please upgrade pry-rails."
        end
      end

      def pry_rails_before_0_1_6?
        begin
          PryRails::VERSION < "0.1.6"
        rescue NameError
          false
        end
      end
    end
  end
end
