$ = require 'jquery'

class Fit
  "use strict"

  _defaults:
    type: 'cover'# 'cover' or 'contain'
    res: 0.5625# 16:9
    maxHeight: null
    minHeight: null
    lineHeight: false

  _init: ->
    @resize()
    return this

  constructor: (@el, opts) ->
    @opts = $.extend {}, @_defaults, opts
    @$el = $(@el)
    @_init()

  setWindowSize: ->
    @_windowWidth = $(window).width()

    if @opts.maxHeight?
      @_windowHeight = @opts.maxHeight
    else if @opts.minHeight? and
    $(window).height() < @opts.minHeight
      @_windowHeight = @opts.minHeight
    else
      @_windowHeight = $(window).height()
    return this

  getWindowSize: ->
    return [
      @_windowWidth
      @_windowHeight
    ]

  calcSize: ->
    @setWindowSize()
    displayRes = @getWindowSize()[1] / @getWindowSize()[0]

    if @opts.res > displayRes
      @_width = @getWindowSize()[0]
      @_height = @_width * @opts.res
      @_marginTop = -((@_height - @getWindowSize()[1]) / 2)
      @_marginLeft = 0
    else
      @_width = @getWindowSize()[1] / @opts.res
      @_height = @_width * @opts.res
      @_marginTop = 0
      @_marginLeft = -((@_width - @getWindowSize()[0]) / 2)
    return this

  cover: ->
    @calcSize()
    @$el.css
      width: @_width
      height: @_height
      marginTop: @_marginTop
      marginLeft: @_marginLeft

    if @opts.lineHeight is true
      @$el.css
        lineHeight: "#{@_height}px"
    return this

  contain: ->

  resize: ->
    if @opts.type is 'cover'
      @cover()
    else if @opts.type is 'contain'
      @contain()
    return this

if typeof define is 'function' and define.amd
  define -> Fit
else if typeof module isnt 'undefined' and module.exports
  module.exports = Fit
else
  window.Fit or= Fit
