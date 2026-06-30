---
redirect_from: /docs/3-index-pages/custom-index.html
---

# Custom Index

If the supplied Active Admin index components are insufficient for your project
feel free to define your own. Index classes inherit from `ActiveAdmin::Component`
and require a `build` method and an `index_name` class method.

```ruby
module ActiveAdmin
  module Views
    class IndexAsMyIdea < ActiveAdmin::Component

      def build(page_presenter, collection)
        # ...
      end

      def self.index_name
        "my_idea"
      end

    end
  end
end
```

The build method takes a PagePresenter object and collection of whatever you
choose.

The `index_name` class method takes no arguments and returns a string that should
be representative of the class name. If this method is not defined, your
index component will not be able take advantage of Active Admin's
*multiple index pages* feature.
