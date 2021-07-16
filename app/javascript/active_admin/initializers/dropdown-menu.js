import DropdownMenu from "../lib/dropdown-menu";

$.widget.bridge('aaDropdownMenu', DropdownMenu);

const onDOMReady = () => $('.dropdown_menu').aaDropdownMenu();

$(document).
  ready(onDOMReady).
  on('page:load turbolinks:load turbo:load', onDOMReady);
