window.AA.DropdownMenu = class AA.DropdownMenu

  constructor: (@options, @element) ->

    @$element = $(@element)

    defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      onClickActionItemCallback: null
    }

    @options = $.extend({}, defaults, options)

    @$menuButton = @$element.find(".dropdown_menu_button")
    @$menuList = @$element.find(".dropdown_menu_list_wrapper")

    @isOpen = false

    @_buildMenuList()
    @_bind()

  open: ->
    @isOpen = true
    @$menuList.fadeIn @options.fadeInDuration

    @_positionMenuList()
    @_positionNipple()

    return @


  close: ->
    @isOpen = false
    @$menuList.fadeOut this.options.fadeOutDuration

    return @

  destroy: ->
    @$element.unbind()
    @$element = null

    return @

  isDisabled: ->
    @$menuButton.hasClass("disabled")

  disable: ->
    @$menuButton.addClass("disabled")

  enable: ->
    @$menuButton.removeClass("disabled")

  option: (key, value) ->
    if $.isPlainObject(key)
      return @options = $.extend(true, @options, key)

    else if key?
      return @options[key]

    else
      return @options[key] = value

  # Private

  _buildMenuList: ->
    @$menuList.prepend("<div class=\"dropdown_menu_nipple\"></div>")
    @$menuList.hide()

  _bind: ->
    $("body").bind 'click', () =>
      if @isOpen is true
          @close()

    @$menuButton.bind 'click', () =>
      unless @isDisabled()
        if @isOpen is true
          @close()
        else
          @open()

      # Return false so that the event is stopped
      false

  _positionMenuList: ->
    centerOfButtonFromLeft = @$menuButton.position().left + @$menuButton.outerWidth() / 2
    centerOfmenuListFromLeft = @$menuList.outerWidth() / 2
    menuListLeftPos = centerOfButtonFromLeft - centerOfmenuListFromLeft
    @$menuList.css "left", menuListLeftPos

  _positionNipple: ->
    centerOfmenuListFromLeft = @$menuList.outerWidth() / 2
    bottomOfButtonFromTop = @$menuButton.position().top + @$menuButton.outerHeight() + 10
    @$menuList.css "top", bottomOfButtonFromTop
    $nipple = @$menuList.find(".dropdown_menu_nipple")
    centerOfnippleFromLeft = $nipple.outerWidth() / 2
    nippleLeftPos = centerOfmenuListFromLeft - centerOfnippleFromLeft
    $nipple.css "left", nippleLeftPos

(($) ->
  $.widget.bridge 'aaDropdownMenu', AA.DropdownMenu

  $ ->
    $(".dropdown_menu").aaDropdownMenu()
)(jQuery)
