ActiveAdmin.after_load do |app|
  app.namespaces.each do |namespace|
    namespace.register_page "Error" do
      menu false

    end
  end
end