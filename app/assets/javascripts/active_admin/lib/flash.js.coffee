ActiveAdmin.flash =
  class Flash
    @error: (message) ->
      new @ message, "error"
    @notice: (message) ->
      new @ message, "notice"
    reference: ->
      @reference
    constructor: (@message, @type = "notice") ->
      @reference = jQuery("<div>").addClass("flash flash_#{type}").text(message)
      jQuery ".flashes"
        .append @reference
    close: ->
      @reference.remove()
