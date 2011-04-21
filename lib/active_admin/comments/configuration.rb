module ActiveAdmin
  module Comments

    module Configuration

      # Set the namespaces that can create and view comments
      #
      #   config.allow_comments_in = [:admin, :root]
      #
      @@allow_comments_in = [ActiveAdmin.default_namespace]
      mattr_accessor :allow_comments_in

    end

  end
end
