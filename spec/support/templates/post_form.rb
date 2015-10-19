require 'reform/form'

class PostForm < Reform::Form
  property :title, validates: { presence: true }
end
