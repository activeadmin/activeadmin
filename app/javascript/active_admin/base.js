import "jquery"
import "jquery-ui/ui/widgets/datepicker"
import "jquery-ui/ui/widgets/dialog"
import "jquery-ui/ui/widgets/sortable"
import "jquery-ui/ui/widgets/tabs"
import "jquery-ui/ui/widget"
import "jquery-ujs"

import "./ext/jquery"
import "./ext/jquery-ui"
import "./initializers/batch-actions"
import "./initializers/checkbox-toggler"
import "./initializers/datepicker"
import "./initializers/dropdown-menu"
import "./initializers/filters"
import "./initializers/has-many"
import "./initializers/per-page"
import "./initializers/table-checkbox-toggler"
import "./initializers/tabs"

import ModalDialog from "./lib/modal-dialog";

function modal_dialog(message, inputs, callback) {
  console.warn("ActiveAdmin.modal_dialog is deprecated in favor of ActiveAdmin.ModalDialog, please update usage.");
  return ModalDialog(message, inputs, callback);
}

export { ModalDialog, modal_dialog };
