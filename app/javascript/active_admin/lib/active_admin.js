import CheckboxToggler from "./checkbox-toggler"
import DropdownMenu from "./dropdown-menu"
import TableCheckboxToggler from "./table-checkbox-toggler"

((window, $) => {

  class ActiveAdmin {

    static get turbolinks() {
      return (typeof Turbolinks !== "undefined" && Turbolinks.supported)
    }

    static turbolinksVisit(params) {
      const path = [window.location.pathname, "?", this.toQueryString(params)].join("")
      Turbolinks.visit(path)
    }

    static queryString() {
      return (window.location.search || "").replace(/^\?/, "")
    }

    static queryStringToParams() {
      const decode = (value) => decodeURIComponent((value || "").replace(/\+/g, "%20"))

      return this.queryString()
        .split("&")
        .map(pair => pair.split("="))
        .map(([key, value]) => {
          return { name: decode(key), value: decode(value) }
        })
    }

    static toQueryString(params) {
      const encode = (value) => encodeURIComponent(value || "")

      return params
        .map(({name, value}) => [ encode(name), encode(value) ])
        .map(pair => pair.join("="))
        .join("&")
    }
  }

  window.activeadmin = ActiveAdmin

  ActiveAdmin.CheckboxToggler = CheckboxToggler
  ActiveAdmin.DropdownMenu = DropdownMenu
  ActiveAdmin.TableCheckboxToggler = TableCheckboxToggler

  $.widget.bridge("checkboxToggler", ActiveAdmin.CheckboxToggler)
  $.widget.bridge("aaDropdownMenu", ActiveAdmin.DropdownMenu)
  $.widget.bridge("tableCheckboxToggler", ActiveAdmin.TableCheckboxToggler)

  const onDOMReady = () => $(".dropdown_menu").aaDropdownMenu()

  $(document).
    ready(onDOMReady).
    on("page:load turbolinks:load", onDOMReady)

})(window, jQuery)
