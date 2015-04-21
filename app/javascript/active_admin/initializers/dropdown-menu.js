import DropdownMenu from "../lib/dropdown-menu";

$.widget.bridge('aaDropdownMenu', DropdownMenu);

const onDOMReady = () => $('.dropdown').aaDropdownMenu();

$(document).
  ready(onDOMReady).
  on('page:load turbolinks:load', onDOMReady);
