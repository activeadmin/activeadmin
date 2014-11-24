# Decorators

Active Admin allows you to use the decorator pattern to provide view-specific
versions of a resource. [Draper](https://github.com/drapergem/draper) is
recommended but not required.

## Decorators with Draper

### Example usage

```ruby
# app/models/post.rb
class Post < ActiveRecord::Base
  # has title, content, and image_url
end

# app/decorators/post_decorator.rb
class PostDecorator < ApplicationDecorator
  delegate_all

  def image
    h.image_tag model.image_url
  end
end

# app/admin/post.rb
ActiveAdmin.register Post do
  decorate_with PostDecorator

  index do
    column :title
    column :image
    actions
  end
end
```

### Forms

By default, ActiveAdmin does *not* decorate the resource used to render forms.
If you need ActiveAdmin to decorate the forms, you can pass `decorate: true` to the
form block.

```ruby
ActiveAdmin.register Post do
  decorate_with PostDecorator

  form decorate: true do |f|
    # ...
  end
end
```

## Non-Draper Decorators

Draper is good for presentation logic, but sometimes you need something dead-simple and with no downsides of draper.
For downsides see [this](http://thepugautomatic.com/2014/03/draper/) article.
In this case use PORO (Plain Old Ruby Object):

### Example usage

```ruby
# app/admin/post.rb
ActiveAdmin.register Post do
  decorate_with PostPresenter

  permit_params :title

  index do
    column :id
    column :title
    column :hello       #delegated
    column :link_title  #delegated
  end
end

# app/presenters/article_presenter.rb
require 'delegated'

class PostPresenter < DelegateClass(Post)
  include Delegated

  def self.model_name
    ActiveModel::Name.new Post
  end

  def self.columns
    Post.columns
  end

  def hello
    "Hello, #{title}"
  end

  def link_title
    helpers.link_to(id, url_helpers.admin_post_path(self))
  end
end

# app/presenters/delegated.rb
module Delegated
  extend ActiveSupport::Concern

  def helpers
    ActionController::Base.helpers
  end

  included do
    delegate :url_helpers, to: "Rails.application.routes"
  end

  module ClassMethods
    def decorate(*args)
      collection_or_object = args[0]
      if collection_or_object.respond_to?(:to_ary)
        class_name = collection_or_object.class.to_s.demodulize.gsub('ActiveRecord_Relation_', '')
        DecoratedEnumerableProxy.new(collection_or_object, class_name)
      else
        new(collection_or_object)
      end
    end

    def helpers
      ActionController::Base.helpers
    end
  end

  class DecoratedEnumerableProxy < DelegateClass(ActiveRecord::Relation)
    include Enumerable

    delegate :as_json, :collect, :map, :each, :[], :all?, :include?, :first, :last, :shift, :to => :decorated_collection

    def initialize(collection, class_name)
      super(collection)
      @class_name = class_name
    end

    def klass
      "#{@class_name}Presenter".constantize
    end

    def wrapped_collection
      __getobj__
    end

    def decorated_collection
      @decorated_collection ||= wrapped_collection.collect { |member| klass.decorate(member) }
    end
    alias_method :to_ary, :decorated_collection

    def each(&blk)
      to_ary.each(&blk)
    end
  end
end
```

### Poroaa gem

Instead of copy-pasting this, you can use [poroaa](https://github.com/kiote/poroaa) gem:

Gemfile
```ruby
gem 'poroaa', github: 'kiote/poroaa'
```

This gem jsut contains ```Delegated``` module