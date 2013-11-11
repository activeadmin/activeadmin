class ActiveAdmin.Popover

  constructor: (@options, @element) ->
    @$element = $(@element)

    defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      autoOpen: true,
      pageWrapperElement: "#wrapper",
      onClickActionItemCallback: null
    }

    @options = $.extend defaults, options
    @isOpen  = false

    unless (@$popover = $ @$element.attr 'href').length
      @$popover = @$element.next '.popover'

    @_buildPopover()
    @_bind()

  open: ->
    @isOpen = true
    @$popover.fadeIn @options.fadeInDuration
    @_positionPopover()
    @_positionNipple()
    @

  close: ->
    @isOpen = false
    @$popover.fadeOut this.options.fadeOutDuration
    @

  destroy: ->
    @$element.removeData 'popover'
    @$element.unbind()
    @$element = null
    @

  # Private

  _buildPopover: ->
    @$nipple = $('<div class="popover_nipple"></div>')
    @$popover.prepend @$nipple
    @$popover.hide()
    @$popover.addClass 'popover'


  _bind: ->
    $(@options.pageWrapperElement).click =>
      @close() if @isOpen

    if @options.autoOpen
      @$element.click (e)=>
        e.stopPropagation()
        if @isOpen then @close() else @open()

  _positionPopover: ->
    button_center = @$element.offset().left + @$element.outerWidth() / 2
    popover_center = @$popover.outerWidth() / 2
    @$popover.css 'left', button_center - popover_center

  _positionNipple: ->
    @$popover.css 'top', @$element.offset().top     + @$element.outerHeight() + 10
    @$nipple.css 'left', @$popover.outerWidth() / 2 - @$nipple.outerWidth() / 2

$.widget.bridge 'popover', ActiveAdmin.Popover
