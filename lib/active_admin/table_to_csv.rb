module ActiveAdmin

  # Convert an Arbre::HTML::Table to CSV
  class TableToCSV
	include ActionView::Helpers::SanitizeHelper

	def initialize(table)
	  @table = table
	end

	def to_s
	  CSV.generate do |csv|

		thead = @table.find_by_tag("thead").first
		csv << thead.find_by_tag("th").collect do |th|
		  th.content
		end

		tbody = @table.find_by_tag("tbody").first
		tbody.find_by_tag("tr").each do |tr|
		  row = tr.find_by_tag("td").map do |td|
			strip_tags(td.content)
		  end
		  csv << row
		end
	  end
	end
  end

end
