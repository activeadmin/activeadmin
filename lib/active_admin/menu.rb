module ActiveAdmin
  class Menu
    
    def initialize
      @items = []
      yield(self) if block_given?
    end  
    
    def add(*args, &block)
      @items << MenuItem.new(*args, &block)
    end
    
    def [](name)
      items.find{ |i| i.name == name }
    end
    
    def items
      @items.sort
    end
    
    def find_by_url(url)
      recursive_find_by_url(items, url)
    end
    
    private
    
    def recursive_find_by_url(collection, url)
      found = nil
      collection.each do |item|
        if item.url == url
          found = item
          break
        else
          found = recursive_find_by_url(item.children, url)
          break if found
        end
      end
      found
    end
    
  end
end
