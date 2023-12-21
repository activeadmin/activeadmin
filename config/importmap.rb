pin "flowbite", to: "https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.0/flowbite.min.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.2/app/assets/javascripts/rails-ujs.esm.js"

# pin_all_from ActiveAdmin::Engine.root.join("app/javascript/active_admin", __dir__)

pin "active_admin", to: "active_admin.js", preload: true
pin_all_from File.expand_path("../app/javascript/active_admin", __dir__), under: "active_admin"
