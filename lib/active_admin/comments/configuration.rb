module ActiveAdmin
  module Comments

    module Configuration
      extend ActiveSupport::Concern

      included do
        # Set the namespaces that can create and view comments
        #
        #   config.allow_comments_in = [:admin, :root]
        #
        attr_accessor :allow_comments_in

        def allow_comments_in
          @allow_comments_in || [:admin]
        end
      end

    end

  end
end
