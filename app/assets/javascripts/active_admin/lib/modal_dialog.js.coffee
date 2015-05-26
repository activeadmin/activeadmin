ActiveAdmin.modal_dialog = (message, inputs, callback)->
  if typeof(inputs) == "string"
    $.get window.location.href + "/batch_action_form_view?partial_name=" + $.parseJSON(inputs), (data) ->
      data = $(data)
      data.find('input[type="submit"]').remove()
      html = """<form id="dialog_confirm" title="#{message}">"""
      html += data.html()
      html += "</form>"
      start_dialog(html)
  else
    html = """<form id="dialog_confirm" title="#{message}"><ul>"""
    for name, type of inputs
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
        <label>#{name.charAt(0).toUpperCase() + name.slice(1)}</label>
        <#{wrapper} name="#{name}" class="#{klass}" type="#{type}">""" +
          (if opts then (
            for v in opts
              $elem = $("<#{elem}/>")
              if $.isArray v
                $elem.text(v[0]).val(v[1])
              else
                $elem.text(v)
              $elem.wrap('<div>').parent().html()
          ).join '' else '') +
        "</#{wrapper}>" +
      "</li>"
      [wrapper, elem, opts, type, klass] = [] # unset any temporary variables

    html += "</ul></form>"
    start_dialog(html)

  start_dialog = (html) ->
    $(html).appendTo('body').dialog
      modal: true
      dialogClass: 'active_admin_dialog'
      buttons:
        OK: ->
          callback $(@).serializeObject()
          $(@).dialog('close')
        Cancel: ->
          $(@).dialog('close').remove()
