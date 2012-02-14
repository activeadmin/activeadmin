<!-- Please don't edit this file. It will be clobbered. -->

# Index as a Grid

Sometimes you want to display the index screen for a set of resources as a grid
(possibly a grid of thumbnail images). To do so, use the :grid option for the
index block.

    index :as => :grid do |product|
      link_to(image_tag(product.image_path), admin_product_path(product))
    end

The block is rendered within a cell in the grid once for each resource in the
collection. The resource is passed into the block for you to use in the view.

You can customize the number of colums that are rendered using the columns
option:

    index :as => :grid, :columns => 5 do |product|
      link_to(image_tag(product.image_path), admin_product_path(product))
    end