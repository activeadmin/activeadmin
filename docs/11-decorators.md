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

In most cases this will work as expected. However, it can have some unexpected
results. Here's an example gotcha:

```ruby
class UserDecorator < Draper::Base
  decorates :user

  def self.status_options_for_select
    User.status_options.map { |s| [s.humanize, s] }
  end

  def status
    model.status.titleize
  end
end

ActiveAdmin.register User do
  form do
    f.inputs do
      f.input :status, collection: UserDecorator.status_options_for_select
    end
  end
end
```

In this example, `f.object.status` now returns "Submitted", which does not match
the actual status option: "submitted". Because of this, the `<select>` will not
have the correct status selected.

