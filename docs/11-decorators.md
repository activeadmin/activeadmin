# Decorators

Active Admin supports the use of decorators for resources. Resources will be
be decorated for the index and show blocks. The [draper](http://github.com/jcasimir/draper)
gem is recommended but not required (more on requirements below).

## Configuration

    ActiveAdmin.register Post do
      decorate_with PostDecorator
    end

## Example Usage

This example uses [draper](http://github.com/jcasimir/draper).

    # Gemfile
    gem 'draper'

Assuming a post and a post decorator

    class Post < ActiveRecord::Base; end

    class PostDecorator < ApplicationDecorator
      decorates :post

      def image
        h.image_tag model.image_url
      end
    end

Then the following is possible

    ActiveAdmin.register Post do
      decorate_with PostDecorator

      index do
        column(:title)
        column(:image)
      end

      show do
        attributes_table do
          row(:title)
          row(:image)
        end
      end
    end
