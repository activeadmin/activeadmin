window.AA.TableCheckboxToggler = class AA.TableCheckboxToggler extends AA.CheckboxToggler
  _init: ->
    super

  _bind: ->
    super

    @$container.find('tbody td').click (e)=>
      @_didClickCell(e.target) if e.target.type isnt 'checkbox'

  _didChangeCheckbox: (checkbox) ->
    super

    $row = $(checkbox).parents 'tr'

    if checkbox.checked
      $row.addClass 'selected'
    else
      $row.removeClass 'selected'

  _didClickCell: (cell) ->
    $(cell).parent('tr').find(':checkbox').click()

jQuery ($)->
  $.widget.bridge 'tableCheckboxToggler', AA.TableCheckboxToggler
