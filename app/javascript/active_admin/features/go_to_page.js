import Rails from '@rails/ujs';

const goToPage = function(event) {
  if (event.key !== "Enter") return;

  const input = this;
  const page = parseInt(input.value, 10);
  const totalPages = parseInt(input.dataset.totalPages, 10);

  if (isNaN(page) || page < 1 || page > totalPages) {
    input.value = input.defaultValue;
    return;
  }

  const params = new URLSearchParams(window.location.search);
  params.set("page", page);
  window.location.search = params;
}

Rails.delegate(document, ".pagination-go-to-page", "keydown", goToPage);
