class ActiveAdmin.DropdownMenu

  constructor: (@options, @element) ->
    @$element = $(@element)

    defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      onClickActionItemCallback: null
    }

    @options = $.extend defaults, options
    @isOpen  = false

    @$menuButton = @$element.find '.dropdown_menu_button'
    @$menuList   = @$element.find '.dropdown_menu_list_wrapper'

    @_buildMenuList()
    @_bind()

  open: ->
    @isOpen = true
    @$menuList.fadeIn @options.fadeInDuration

    @_positionMenuList()
    @_positionNipple()
    @


  close: ->
    @isOpen = false
    @$menuList.fadeOut this.options.fadeOutDuration
    @

  destroy: ->
    @$element.unbind()
    @$element = null
    @

  isDisabled: ->
    @$menuButton.hasClass 'disabled'

  disable: ->
    @$menuButton.addClass 'disabled'

  enable: ->
    @$menuButton.removeClass 'disabled'

  option: (key, value) ->
    if $.isPlainObject(key)
      @options = $.extend(true, @options, key)
    else if key?
      @options[key]
    else
      @options[key] = value

  # Private

  _buildMenuList: ->
    @$nipple = $('<div class="dropdown_menu_nipple"></div>')
    @$menuList.prepend @$nipple
    @$menuList.hide()

  _bind: ->
    $('body').click =>
      @close() if @isOpen

    @$menuButton.click (e)=>
      e.stopPropagation()
      unless @isDisabled()
        if @isOpen then @close() else @open()

  _positionMenuList: ->
    button_center = @$menuButton.position().left + @$menuButton.outerWidth() / 2
    menu_center   = @$menuList.outerWidth() / 2
    @$menuList.css 'left', button_center - menu_center

  _positionNipple: ->
    @$menuList.css 'top',  @$menuButton.position().top + @$menuButton.outerHeight() + 10
    @$nipple.css   'left', @$menuList.outerWidth() / 2 - @$nipple.outerWidth() / 2

$.widget.bridge 'aaDropdownMenu', ActiveAdmin.DropdownMenu

$ ->
  $('.dropdown_menu').aaDropdownMenu()
