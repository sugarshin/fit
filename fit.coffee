do (root = this, factory = ($, td) ->
  "use strict"

  if td is undefined then td = $

  class Fit

    _$window = $(window)

    _defaults:
      type: 'cover' # 'cover' or 'contain'
      ratio: 0.5625 # 16:9
      maxHeight: null
      minHeight: null
      lineHeight: false
      delay: 400
      delayType: 'debounce'# or 'throttle'

    # https://github.com/klughammer/node-randomstring
    _getRandomString: do ->
      chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghiklmnopqrstuvwxyz'
      return (length = 32) ->
        string = ''
        for i in [0...length]
          randomNumber = Math.floor(Math.random() * chars.length)
          string += chars.substring(randomNumber, randomNumber + 1)
        return string

    _configure: (el, opts) ->
      @$el = $(el)
      @opts = $.extend {}, @_defaults, opts
      @_namespace = @_getRandomString()

    constructor: (@el, opts) ->
      @_configure @el, opts
      @events()
      @resize()

    setWindowSize: ->
      @_windowWidth = _$window.width()
      windowHeight = _$window.height()
      if @opts.maxHeight?
        @_windowHeight = @opts.maxHeight
      else if @opts.minHeight? and
      windowHeight < @opts.minHeight
        @_windowHeight = @opts.minHeight
      else
        @_windowHeight = windowHeight
      return this

    getWindowSize: ->
      return [
        @_windowWidth
        @_windowHeight
      ]

    _calcCover: ->
      @setWindowSize()
      displayRatio = @getWindowSize()[1] / @getWindowSize()[0]

      if @opts.ratio > displayRatio
        @_width = @getWindowSize()[0]
      else
        @_width = @getWindowSize()[1] / @opts.ratio

      @_height = @_width * @opts.ratio
      @_marginTop = -(@_height / 2)
      @_marginLeft = -(@_width / 2)
      return this

    _calcContain: ->
      @setWindowSize()
      displayRatio = @getWindowSize()[1] / @getWindowSize()[0]

      if @opts.ratio > displayRatio
        @_height = @getWindowSize()[1] 
        @_width = @_height / @opts.ratio
        @_marginTop = -(@getWindowSize()[1] / 2)
        @_marginLeft = -(@_width / 2)
      else
        @_width = @getWindowSize()[0]
        @_height = @_width * @opts.ratio
        @_marginTop = -(@_height / 2)
        @_marginLeft = -(@getWindowSize()[0] / 2)
      return this

    resize: ->
      if @opts.type is 'cover'
        @_calcCover()
      else if @opts.type is 'contain'
        @_calcContain()

      @$el.css
        width: @_width
        height: @_height
        marginTop: @_marginTop
        marginLeft: @_marginLeft

      if @opts.lineHeight is true
        @$el.css
          lineHeight: "#{@_height}px"
      return this

    events: ->
      _$window.on "resize.fit:#{@_namespace}", td[@opts.delayType] @opts.delay, =>
        @resize()
      return this

    unbind: ->
      _$window.off "resize.fit:#{@_namespace}"
      return this

) ->
  if typeof module is 'object' and typeof module.exports is 'object'
    module.exports = factory require('jquery'), require('throttle-debounce')
  else
    root.Fit or= factory root.jQuery
  return
