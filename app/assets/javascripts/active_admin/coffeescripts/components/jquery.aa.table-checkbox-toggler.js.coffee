window.AA.TableCheckboxToggler = class AA.TableCheckboxToggler extends AA.CheckboxToggler
  _init: ->
    super

  _bind: ->
    super

    @$container.find("tbody").find("td").bind "click", (e) =>
      if e.target.type != 'checkbox'
        @_didClickCell(e.target)
    
  _didChangeCheckbox: (checkbox) ->
    super
    
    $row = $(checkbox).parents("tr")

    if checkbox.checked
      $row.addClass("selected")
    else
      $row.removeClass("selected")

  _didClickCell: (cell) ->
    $(cell).parent("tr").find(':checkbox').click()
    
( ( $ ) ->
  $.widget.bridge 'tableCheckboxToggler', AA.TableCheckboxToggler
)( jQuery )


