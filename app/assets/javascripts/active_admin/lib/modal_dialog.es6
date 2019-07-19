ActiveAdmin.modal_dialog = function(message, inputs, callback) {
  let html = `<form id="dialog_confirm" title="${message}"><ul>`;
  for (let name in inputs) {
    var elem, opts, wrapper, klassOptions = '', attrOptions='';
    let type = inputs[name];
    if (/^(datepicker|checkbox|text|number|textarea)$/.test(type)) {
        wrapper = type === 'textarea' ? 'textarea' : 'input';
    } else if ($.isArray(type)) {
      if ((/^(datepicker|checkbox|text|number|textarea)$/.test(type[0]))) {
        wrapper = type[0] === 'textarea' ? 'textarea' : 'input';
        for (let option in type[1]) {
          if (/^(klassOptions)$/.test(option)) {
            klassOptions = type[1][option];
          } else if (/^(attrOptions)$/.test(option)) {
            attr = "";
            for (let attrType in type[1][option]) {
              attr += `${attrType}="${type[1][option][attrType]}" `
            }
            attrOptions = attr;
          }
        }
        type = type[0];
      } else {
        [wrapper, elem, opts, type] = ['select', 'option', type, ''];
      }
    } else {
      throw new Error(`Unsupported input type: {${name}: ${type}}`);
    }

    let klass = type === 'datepicker' ? type : klassOptions;
    html += `<li>
      <label>${name.charAt(0).toUpperCase() + name.slice(1)}</label>
      <${wrapper} name="${name}" class="${klass}" type="${type}" ${attrOptions}>` +
        (opts ? ((() => {
          const result = [];

          opts.forEach(v => {
            const $elem = $(`<${elem}/>`);
            if ($.isArray(v)) {
              $elem.text(v[0]).val(v[1]);
            } else {
              $elem.text(v);
            }
            result.push($elem.wrap('<div>').parent().html());
          });

          return result;
        })()).join('') : '') +
      `</${wrapper}>` +
    "</li>";
    [wrapper, elem, opts, type, klass, klassOptions, attrOptions] = []; // unset any temporary variables
  }

  html += "</ul></form>";

  const form = $(html).appendTo('body');
  $('body').trigger('modal_dialog:before_open', [form]);

  form.dialog({
    modal: true,
    open(event, ui) {
      $('body').trigger('modal_dialog:after_open', [form]);
    },
    dialogClass: 'active_admin_dialog',
    buttons: {
      OK() {
        callback($(this).serializeObject());
        $(this).dialog('close');
      },
      Cancel() {
        $(this).dialog('close').remove();
      }
    }
  });
};