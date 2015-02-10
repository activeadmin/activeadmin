class ActiveAdmin.PerPage
  constructor: (@options, @element)->
    @$element = $(@element)
    @_init()
    @_bind()

  _init: ->
    @$params = @_queryParams()

  _bind: ->
    @$element.change =>
      @$params['per_page'] = @$element.val()
      delete @$params['page']
      location.search = $.param(@$params)

  _queryParams: ->
    query = window.location.search.substring(1)
    params = {}
    re = /([^&=]+)=([^&]*)/g
    while m = re.exec(query)
      params[decodeURIComponent(m[1])] = decodeURIComponent(m[2])
    params

$.widget.bridge 'perPage', ActiveAdmin.PerPage

$ ->
  $('.pagination_per_page select').perPage()
