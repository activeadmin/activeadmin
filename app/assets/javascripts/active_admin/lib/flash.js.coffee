ActiveAdmin.flash =
  class Flash
    @error: (message, close_after) ->
      new @ message, "error", close_after
    @notice: (message, close_after) ->
      new @ message, "notice", close_after
    reference: ->
      @reference
    constructor: (@message, @type = "notice", close_after) ->
      @reference = jQuery("<div>").addClass("flash flash_#{@type}").text(@message)
      jQuery ".flashes"
        .append @reference
      @close_after close_after if close_after?
    close_after: (close_after) ->
      setTimeout =>
        @close()
      , close_after * 1000
    close: ->
      @reference.remove()
