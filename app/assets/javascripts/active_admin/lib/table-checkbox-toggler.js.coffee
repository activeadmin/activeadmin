class ActiveAdmin.TableCheckboxToggler extends ActiveAdmin.CheckboxToggler
  _init: ->
    super

  _bind: ->
    super

    @$container.find('tbody td').click (e)=>
      @_didClickCell(e.target) if e.target.type isnt 'checkbox'

  _didChangeCheckbox: (checkbox) ->
    super

    $(checkbox).parents('tr').toggleClass 'selected', checkbox.checked

  _didChangeToggleAllCheckbox: ->
    @$container.find('tbody tr').toggleClass 'selected', super

  _didClickCell: (cell) ->
    $(cell).parent('tr').find(':checkbox').click()

$.widget.bridge 'tableCheckboxToggler', ActiveAdmin.TableCheckboxToggler
