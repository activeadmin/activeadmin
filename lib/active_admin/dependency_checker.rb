require 'rails/version'

module ActiveAdmin
  module DependencyChecker
    class << self
      def check!
        confirm_asset_gems_are_installed unless Rails.env.production?

        if rails_3_1?
          unless meta_search_1_1? && sass_rails_3_1?
            warn "ActiveAdmin requires meta_search >= 1.1.0.pre and sass-rails ~> 3.1.0.rc to work with rails >= 3.1.0"
          end
        end

        if pry_rails_before_0_1_6?
          warn "ActiveAdmin is not compatible with pry-rails < 0.1.6. Please upgrade pry-rails."
        end
      end

      def confirm_asset_gems_are_installed
        %w[bourbon coffee-rails jquery-rails sass-rails].each do |name|
          begin
            gem name
          rescue Gem::LoadError
            raise "ActiveAdmin depends on #{name}. Please add it to your Gemfile."
          end
        end
      end

      def rails_3_1?
        Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 1
      end

      def meta_search_1_1?
        Gem.loaded_specs['meta_search'].version.to_s >= "1.1"
      end

      def sass_rails_3_1?
        require 'sass/rails/version'
        ::Sass::Rails::VERSION >= "3.1"
      rescue LoadError
        false
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
