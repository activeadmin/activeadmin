module ActiveAdmin
  module Pages

    class Index < Base
      def title
        resources_name
      end

      # Render's the index configuration that was set in the
      # controller. Defaults to rendering the ActiveAdmin::Pages::Index::Table
      def main_content
        index_config.render(self, collection)
      end


      #
      # Index Page Configurations
      #      

      class Table < PageConfig

        attr_reader :table_builder

        def initialize(*args, &block)
          @table_builder = TableBuilder.new(&block)
          super
        end

        # 
        # Extend the default ActiveAdmin::TableBuilder with some
        # methods for quickly displaying items on the index page
        #
        class TableBuilder < ::ActiveAdmin::TableBuilder

          # Adds links to View, Edit and Delete
          def default_actions(options = {})
            options = {
              :name => ""
            }.merge(options)
            column options[:name] do 
              links = link_to "View", resource_path(resource)
              links += " | "
              links += link_to "Edit", edit_resource_path(resource)
              links += " | "
              links += link_to "Delete", resource_path(resource), :method => :delete, :confirm => "Are you sure you want to delete this?"
              links
            end
          end          

        end

        def render(view, collection)
          Renderer.new(view).to_html(self, collection)
        end

        class Renderer < ::ActiveAdmin::Renderer

          def to_html(config, collection)
            wrap_with_pagination(collection, :entry_name => resource_name) do
              table_options = {
                :id => resource_name.underscore.pluralize, 
                :resource_instance_name => resource_name.underscore.gsub(" ", "_"),
                :sortable => true,
                :class => "index_table", 
              }
              config.table_builder.to_html(self, collection, table_options)
            end
          end

        end # Renderer
      end # Table


      class Posts < PageConfig

        attr_accessor :title, :content

        def initialize(*args, &block)
          super
          block.call(Builder.new(self)) if block_given?
        end

        class Builder
          def initialize(posts_config)
            @posts_config = posts_config
          end

          def title(method = nil, &block)
            @posts_config.title = block_given? ? block : method
          end

          def content(method = nil, &block)
            @posts_config.content = block_given? ? block : method
          end
        end

        class Renderer < ::ActiveAdmin::Renderer

          def to_html(config, collection)
            @config = config
            wrap_with_pagination(collection, :entry_name => resource_name) do
              content_tag :div do
                collection.collect{|item| render_post(item) }.join
              end
            end
          end

          def title_content(post)
            case @config.title
            when Symbol
              post.send @config.title
            when Proc
              setup_instance_variables(post)
              instance_eval(&@config.title)
            else
              "#{resource_name} #{post.id}"
            end
          end

          def content(post)
            case @config.content
            when Symbol
              post.send @config.content
            when Proc
              setup_instance_variables(post)
              instance_eval(&@config.content)              
            else
              ""
            end            
          end

          def render_post(post)
            content_tag_for :div, post do
              title = content_tag :h3, link_to(title_content(post), resource_path(post))
              main_content = content_tag(:div, content(post), :class => 'content')
              title + main_content
            end
          end

          protected

          def setup_instance_variables(post)
            @resource = post && instance_variable_set("@#{resource_instance_name}", post)
          end

        end
      end

    end
  end
end
