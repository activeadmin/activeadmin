# frozen_string_literal: true
pin "flowbite", preload: true # downloaded from https://cdnjs.cloudflare.com/ajax/libs/flowbite/2.2.1/flowbite.min.js
pin "@rails/ujs", to: "rails_ujs_esm.js", preload: true # downloaded from https://cdn.jsdelivr.net/npm/@rails/ujs@7.1.400/+esm
pin "active_admin", to: "active_admin.js", preload: true
pin_all_from File.expand_path("../app/javascript/active_admin", __dir__), under: "active_admin", preload: true
