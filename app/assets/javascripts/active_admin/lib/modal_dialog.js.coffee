ActiveAdmin.modal_dialog = (message, inputs, callback)->
  html = """<form id="dialog_confirm" title="#{message}"><ul>"""
  for name, definition of inputs
    label = name
    type = definition
    if definition.type
      type = definition.type

    if definition.label
      label = definition.label

    if /^(datepicker|checkbox|text)$/.test type
      wrapper = 'input'
    else if type is 'textarea'
      wrapper = 'textarea'
    else if $.isArray type
      [wrapper, elem, opts, type] = ['select', 'option', type, '']
    else
      throw new Error "Unsupported input type: {#{name}: #{type}}"

    klass = if type is 'datepicker' then type else ''
    html += """<li>
      <label>#{label.charAt(0).toUpperCase() + label.slice(1)}</label>
      <#{wrapper} name="#{name}" class="#{klass}" type="#{type}">""" +
        (if opts then (
          for v in opts
            if $.isArray v
              "<#{elem} value=#{v[1]}>#{v[0]}</#{elem}>"
            else
              "<#{elem}>#{v}</#{elem}>"
        ).join '' else '') +
      "</#{wrapper}>" +
    "</li>"
    [wrapper, elem, opts, type, klass] = [] # unset any temporary variables

  html += "</ul></form>"
  $(html).appendTo('body').dialog
    modal: true
    dialogClass: 'active_admin_dialog'
    buttons:
      OK: ->
        callback $(@).serializeObject()
        $(@).dialog('close')
      Cancel: ->
        $(@).dialog('close').remove()
