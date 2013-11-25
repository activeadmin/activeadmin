require 'draper'

class PostDecorator < Draper::Decorator
  delegate_all

  def decorator_method
    'A method only available on the decorator'
  end
end

