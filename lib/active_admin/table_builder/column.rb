module ActiveAdmin
  class TableBuilder
    class Column
      
      attr_accessor :title, :data
      
      def initialize(title, data = nil, &block)
        @title = pretty_title title
        @data  = data.nil? ? title : data        
        @data = block if block
      end
      
      private
      
      def pretty_title(raw)
        raw.is_a?(Symbol) ? raw.to_s.split('_').collect{|s| s.capitalize }.join(' ') : raw
      end
      
    end
  end
end