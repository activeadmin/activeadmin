# Decorators

Active Admin supports the use of decorators for resources. Resources will be
be decorated for the index and show blocks. The
[draper](https://github.com/drapergem/draper) gem is recommended but not required
(more on requirements below). Note, that Active Admin works out of the box with
Draper `>= 1.0.0`.

## Configuration

    ActiveAdmin.register Post do
      decorate_with PostDecorator
    end

## Example Usage

This example uses [draper](https://github.com/drapergem/draper).

    # Gemfile
    gem 'draper', '>= 1.0.0'

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

## Forms

Note that the resource proveded to form_for also gets decorated.

In most cases this will work as expected. However, it is possible to disable
automatic decoration in the form with the `decorate` option:

    ActiveAdmin.register Post do
      decorate_with PostDecorator

      form decorate: false do
        # ...
      end
    end

