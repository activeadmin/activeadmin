ActiveAdmin.after_load do |app|
  app.namespaces.each do |namespace|
    namespace.register_page "Error" do
      menu false

      content title: proc { "Error #{env["active_admin.original_exception"].status_code}" }
    end
  end
end
