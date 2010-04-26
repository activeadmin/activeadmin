module ActiveAdmin
  class IndexBuilder
    
    # IndexBuilder#display_method should return the name of the method
    # to be used in the view to display this configuration.
    def display_method
      raise "#{self.class.name}#display_method has not been defined. Please override #{self.class.name}#display_method and return the name of the method to use in the view"
    end
    
  end
end