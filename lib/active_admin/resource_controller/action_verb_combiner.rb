module ActiveAdmin
  class ResourceController < BaseController
    module ActionVerbCombiner
      private

      # Add behaviour to an existing action, depending on http method,
      # when the same action name is specified.
      #
      # For example:
      #
      #   ActiveAdmin.register Post do
      #     member_action :comments, method: :get do
      #       @post = Post.find(params[:id]
      #       @comments = @post.comments
      #     end
      #
      #     member_action :comments, method: :post do
      #       @post = Post.find(params[:id]
      #       @post.comments.create!(comment_params)
      #     end
      #   end
      #
      # Will be equivalent to:
      #
      #   ActiveAdmin.register Post do
      #     member_action :comments, method: [:get, :post] do
      #       if request.post?
      #         @post = Post.find(params[:id]
      #         @post.comments.create!(comment_params)
      #       else
      #         @post = Post.find(params[:id]
      #         @comments = @post.comments
      #       end
      #     end
      #   end
      #
      def add_behaviour_to_action(action_name, http_verbs, &block)
        old_method_name = add_alias_for_old_behaviour(action_name)
        new_method_name = add_method_for_new_behaviour(action_name, &block)

        define_method(action_name) do
          if request.method_symbol.in?(http_verbs)
            send new_method_name
          else
            send old_method_name
          end
        end
      end

      def add_alias_for_old_behaviour(action_name)
        method_name = resolve_method_name(action_name, "old")
        alias_method method_name, action_name

        private method_name

        method_name
      end

      def add_method_for_new_behaviour(action_name, &block)
        method_name = resolve_method_name(action_name, "new")
        define_method method_name, &block

        private method_name

        method_name
      end

      def resolve_method_name(action_name, postfix)
        next_name = "#{action_name}_#{postfix}"

        while private_method_defined?(next_name) || method_defined?(next_name)
          next_name = "#{next_name}_#{postfix}"
        end

        next_name
      end
    end
  end
end
