module ActiveAdmin
  # This class decorates a collection of objects delegating
  # mehods to behave like an Array. It's used to decouple ActiveAdmin
  # from Draper and thus being able to use PORO decorators as well.
  #
  # It's implementation is heavily based on the Draper::CollectionDecorator
  # https://github.com/drapergem/draper/blob/aaa06bd2f1e219838b241a5534e7ca513edd1fe2/lib/draper/collection_decorator.rb
  class CollectionDecorator
    # @return the collection being decorated.
    attr_reader :object

    # @return [Class] the decorator class used to decorate each item, as set by {#initialize}.
    attr_reader :decorator_class

    array_methods = Array.instance_methods - Object.instance_methods
    delegate :==, :as_json, *array_methods, to: :decorated_collection

    def initialize(object, with:)
      @object = object
      @decorator_class = with
    end

    class << self
      alias_method :decorate, :new
    end

    def decorated_collection
      @decorated_collection ||= object.map { |item| decorator_class.new(item) }
    end
  end
end
