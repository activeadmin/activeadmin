
window.AA.Popover = class AA.Popover

  constructor: (@options, @element) ->

    @$element = $(@element)

    defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      autoOpen: true,
      pageWrapperElement: "#wrapper",
      onClickActionItemCallback: null
    }

    @options = $.extend({}, defaults, options)

    @$popover = null
    @isOpen = false

    if $(@$element.attr("href")).length > 0
      @$popover = $(@$element.attr("href"))
    else
      @$popover = @$element.next(".popover")


    @_buildPopover()
    @_bind()

  open: ->
    @isOpen = true
    @$popover.fadeIn @options.fadeInDuration

    @_positionPopover()
    @_positionNipple()

    return @


  close: ->
    @isOpen = false;
    @$popover.fadeOut this.options.fadeOutDuration;

    return @

  destroy: ->
    @$element.removeData('popover');
    @$element.unbind();
    @$element = null;

    return @

  option: ->
    # ??

  # Private

  _buildPopover: ->
    @$popover.prepend("<div class=\"popover_nipple\"></div>")

    @$popover.hide()

    @$popover.addClass "popover"


  _bind: ->
    $(@options.pageWrapperElement).bind 'click', (e) =>
      if @isOpen is true
        @close()

    if @options.autoOpen is true
      @$element.bind 'click', () =>
        if @isOpen is true
          @close()
        else
          @open()

        false

  _positionPopover: ->
    centerOfButtonFromLeft = @$element.offset().left + @$element.outerWidth() / 2
    centerOfPopoverFromLeft = @$popover.outerWidth() / 2
    popoverLeftPos = centerOfButtonFromLeft - centerOfPopoverFromLeft
    @$popover.css "left", popoverLeftPos

  _positionNipple: ->
    centerOfPopoverFromLeft = @$popover.outerWidth() / 2
    bottomOfButtonFromTop = @$element.offset().top + @$element.outerHeight() + 10
    @$popover.css "top", bottomOfButtonFromTop
    $nipple = @$popover.find(".popover_nipple")
    centerOfnippleFromLeft = $nipple.outerWidth() / 2
    nippleLeftPos = centerOfPopoverFromLeft - centerOfnippleFromLeft
    $nipple.css "left", nippleLeftPos

(($) ->
  $.widget.bridge 'popover', AA.Popover
)(jQuery)
