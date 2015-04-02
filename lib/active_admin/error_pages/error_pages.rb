ActiveAdmin.after_load do |app|
  app.namespaces.each do |namespace|
    namespace.register_page "Error" do
      menu false

      content title: proc{ "Error #{status_code}" }

    end
  end
end
