# frozen_string_literal: true
pin "flowbite", preload: true # downloaded from https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.js
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@7.1.2/app/assets/javascripts/rails-ujs.esm.js", preload: true
pin "active_admin", to: "active_admin.js", preload: true
pin_all_from File.expand_path("../app/javascript/active_admin", __dir__), under: "active_admin", preload: true
