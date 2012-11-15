# Arbre Components

Arbre allows the creation of shareable and extendable HTML components and is
used throughout Active Admin to create view components.

## Text Node

Sometimes it makes sense to insert something into a registered resource like a
non-breaking space or some text. The text_node method can be used to insert
these elements into the page inside of other Arbre components or resource
controller functions.

	ActiveAdmin.register Post do
		show do
			panel "Post Details" do
				row("") { post.id }
				row("Tags") do
					text_node link_to "#{tag}", 
						admin_post_path( q: { tagged_with_contains: tag } )
					text_node "&nbsp".html_safe
				end
			end
		end
	end

## Common Components

### Panel Component

A panel is a component that takes up all available horizontal space and takes a
title and a hash of attributes as arguments. If a sidebar is present, a panel
will take up the remaining space.

The following code will create two stacked panels:

    show do

      panel "Post Details" do
        render partial: "show_details", locals: {post: post}
      end

      panel "Post Tags" do
        render partial: "show_enhancements", locals: {post: post}
      end

    end

### Columns Component

The Columns component allows you draw content into scalable columns. All you
need to do is define the number of columns and the component will take care of
the rest.

#### Simple Columns
	
To create simple columnns, use the #columns method. Within the block, call the
#column method to create a new column.

	columns do
	  
	  column do
		span "Column #1"
	  end
	  
	  column do
		span "Column #2"
	  end

	end

#### Multiple Span Columns

To create columns that have multiple spans, pass the :span option to the column
method.

	columns do
      column :span => 2 do
        span "Column # 1
      end
      column do
        span "Column # 2
      end
    end

By default, each column spans 1 column. The above layout would have 2 columns,
the first being twice as large as the second.

#### Max and Mix Column Sizes

Active Admin uses a fluid width layout, causing column width to be defined
using percentages. Due to using this style of layout, columns can shrink or
expand past points that may not be desirable. To overcome this issue,
columns provide :max_width and :min_width options.

    columns do
      column :max_width => "200px", :min_width => "100px" do
        span "Column # 1
      end
      column do
        span "Column # 2
      end
    end

In the above example, the first column will not grow larger than 200px and will
not shrink less than 100px.

### Table For Component
 
Table For provides the ability to create tables like those present in
#index_as_table. table_for takes a collection and a hash of options and then
uses #column to build the fields to show with the table.

	table_for order.payments do
	  column "Payment Type" { |payment| payment.payment_type.titleize }
	  column "Received On", :created_at
	  column "Payment Details & Notes", :payment_details
	  column "Amount" { |payment| payment.amount_in_dollars }
	end

the #column method can take a title as its first argument and data
(:your_method) as its second (or first if no title provided). Column also
takes a block.

### Status tag

Status tags provide convenient syntactic sugar for styling items that have
status. A common example of where the status tag could be useful is for orders
that are complete or in progress. status_tag takes a status, like
"In Progress", a type, which defaults to nil, and a hash of options. The
status_tag will generate html markup that Active Admin css uses in styling.

    status_tag('In Progress')
    # => <span class='status_tag in_progress'>In Progress</span>
  
    status_tag('active', :ok)
    # => <span class='status_tag active ok'>Active</span>
  
    status_tag (
      'active', 
      :ok, 
      :class => 'important', 
      :id => 'status_123', 
      :label => 'on'
    )
    # => <span class='status_tag active ok important' id='status_123'>on</span>
