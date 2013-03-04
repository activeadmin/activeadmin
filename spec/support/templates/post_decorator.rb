# Minimal example of a decorator
require_dependency 'post'

# DelegateClass(Post) does not delegate attribute methods
# in some environments:
# http://travis-ci.org/#!/gregbell/active_admin/jobs/2021466
#
class PostDecorator < SimpleDelegator
  delegate :id, :to => :__getobj__

  def self.decorate(object)
    new(object)
  end

  def self.decorate_collection(collection)
    DecoratedEnumerableProxy.new(collection)
  end

  def self.model_name
    ActiveModel::Name.new Post
  end

  def decorator_method
    'A method only available on the decorator'
  end

  # Minimal example of decorating a collection.
  # A full example can be found in the draper project:
  # https://github.com/jcasimir/draper/blob/master/lib/draper/decorated_enumerable_proxy.rb
  class DecoratedEnumerableProxy < DelegateClass(ActiveRecord::Relation)
    include Enumerable

    delegate :as_json, :collect, :map, :each, :[], :all?, :include?, :first, :last, :shift, :to => :decorated_collection

    def klass
      PostDecorator
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

