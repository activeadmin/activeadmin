window.AA.modalDialog = (message, inputs, callback)->
  html = """<form id="dialog_confirm" title="#{message}"><ul>"""
  for name, type of inputs
    if /^datepicker|checkbox|text$/.test type
      wrapper = 'input'
    else if type is 'textarea'
      wrapper = 'textarea'
    else if $.isArray type
      [wrapper, elem, opts, type] = ['select', 'option', type, '']
    else
      console.warn "Unsupported input type: {#{name}: #{type}}"

    klass = if type is 'datepicker' then type else ''
    html += """<li><label>#{name.charAt(0).toUpperCase() + name.slice(1)}</label><#{wrapper} name="#{name}" class="#{klass}" type="#{type}">""" +
      (if opts then ("<#{elem}>#{v}</#{elem}>" for v in opts).join '' else '') +
      "</#{wrapper}></li>"

  html += "</ul></form>"
  $(html).appendTo('body').dialog
    modal: true #, width: 310 #, show: 'slide' # slide/drop/fade
    buttons:
      OK: ->
        callback $(@).serializeObject()
        $(@).dialog('close')
      Cancel: ->
        $(@).dialog('close').remove()
  $('input').blur() # prevent auto-focus event, so datepicker can be initialized
  $('.ui-dialog .datepicker:not(.hasDatepicker)').datepicker dateFormat: "yy-mm-dd" # remove this when Active Admin's updated to handle dynamically-added datepickers
