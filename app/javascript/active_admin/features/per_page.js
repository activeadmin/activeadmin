import { delegate } from "@rails/ujs";

const setPerPage = function(event) {
  const params = new URLSearchParams(window.location.search)
  params.set("per_page", this.value)
  window.location.search = params
}

delegate(document, ".pagination_per_page > select", "change", setPerPage)
