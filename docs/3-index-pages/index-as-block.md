---
redirect_from: /docs/3-index-pages/index-as-block.html
---

# Index as a Block

If you want to fully customize the display of your resources on the index
screen, Index as a Block allows you to render a block of content for each
resource.

```ruby
index as: :block do |product|
  div for: product do
    resource_selection_cell product
    h2  auto_link     product.title
    div simple_format product.description
  end
end
```
