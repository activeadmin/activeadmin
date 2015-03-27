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
    @$menuList.hide()

  _bind: ->
    $('body').click =>
      @close() if @isOpen

    @$menuButton.click =>
      unless @isDisabled()
        if @isOpen then @close() else @open()
      false

$.widget.bridge 'aaDropdownMenu', ActiveAdmin.DropdownMenu

$(document).on 'ready page:load', ->
  $('.dropdown_menu').aaDropdownMenu()
