module ActiveAdmin
  module Views

    # Loads all the classes in views/*.rb
    Dir[File.expand_path('../views', __FILE__) + "/**/*.rb"].sort.each{ |f| require f }

  end
end
