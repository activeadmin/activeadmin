class ActiveAdmin.DropdownMenu

  constructor: (@options, @element) ->
    @$element = $(@element)

    defaults = {
      fadeInDuration: 20,
      fadeOutDuration: 100,
      onClickActionItemCallback: null
    }

    @options = $.extend defaults, @options
    @isOpen  = false

    @$menuButton = @$element.find '.dropdown_menu_button'
    @$menuList   = @$element.find '.dropdown_menu_list_wrapper'

    @_buildMenuList()
    @_bind()

  open: ->
    @isOpen = true
    @$menuList.fadeIn @options.fadeInDuration

    @_position()
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

    @$menuButton.click =>
      unless @isDisabled()
        if @isOpen then @close() else @open()
      false

  _position: ->
    @$menuList.css 'top', @$menuButton.position().top + @$menuButton.outerHeight() + 10

    button_left = @$menuButton.position().left
    button_center =  @$menuButton.outerWidth() / 2
    button_right = button_left + button_center * 2
    menu_center = @$menuList.outerWidth() / 2
    nipple_center = @$nipple.outerWidth() / 2
    window_right = $(window).width()

    centered_menu_left = button_left + button_center - menu_center
    centered_menu_right = button_left + button_center + menu_center

    if centered_menu_left < 0
      # Left align with button
      @$menuList.css 'left', button_left
      @$nipple.css   'left', button_center - nipple_center
    else if centered_menu_right > window_right
      # Right align with button
      @$menuList.css 'right', window_right - button_right
      @$nipple.css   'right', button_center - nipple_center
    else
      # Center align under button
      @$menuList.css 'left', centered_menu_left
      @$nipple.css   'left', menu_center - nipple_center

$.widget.bridge 'aaDropdownMenu', ActiveAdmin.DropdownMenu

$(document).on 'ready page:load', ->
  $('.dropdown_menu').aaDropdownMenu()
