# frozen_string_literal: true
class PostPoroDecorator
  delegate_missing_to :post

  def initialize(post)
    @post = post
  end

  def decorator_method
    "A method only available on the PORO decorator"
  end

  private

  attr_reader :post
end
