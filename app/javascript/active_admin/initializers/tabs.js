let onDOMReady = () =>
  $('#active_admin_content .tabs').tabs()

$(document).
  ready(onDOMReady).
  on('page:load turbolinks:load turbo:load', onDOMReady)
