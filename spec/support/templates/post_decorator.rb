require 'draper'

class PostDecorator < Draper::Decorator
  decorates :post
  delegate_all

  # @param attributes [Hash]
  def assign_attributes(attributes)
    object.assign_attributes attributes.except(:virtual_title)
    self.virtual_title = attributes.fetch(:virtual_title) if attributes.key?(:virtual_title)
  end

  def virtual_title
    object.title
  end

  def virtual_title=(virtual_title)
    object.title = virtual_title
  end

  def decorator_method
    'A method only available on the decorator'
  end
end
