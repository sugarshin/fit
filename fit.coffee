###!
 * @license fit
 * (c) sugarshin
 * License: MIT
###

do (root = this, factory = ($, td) ->
  "use strict"

  if td is undefined then td = $

  class Fit

    _$window = $(window)

    _defaults:
      type: 'cover' # 'cover' or 'contain'
      ratio: 0.5625 # 16:9
      parent: 'window'
      lineHeight: false
      delay: 400
      delayType: 'throttle' # or 'debounce'

    # https://github.com/klughammer/node-randomstring
    _getRandomString: do ->
      chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghiklmnopqrstuvwxyz'
      return (length = 32) ->
        string = ''
        for i in [0...length]
          randomNumber = Math.floor(Math.random() * chars.length)
          string += chars.substring(randomNumber, randomNumber + 1)
        return string

    _initStyling: ->
      @$el.css
        position: 'absolute'
        top: '50%'
        left: '50%'
        height: '100%'

      $parent = if @opts.parent is 'window' then $('body') else @_$parent
      $parent.css
        position: 'relative'
        overflow: 'hidden'

    _configure: (el, opts) ->
      @$el = $(el)
      @opts = $.extend {}, @_defaults, opts
      @_$parent = $((if @opts.parent is 'window' then window else @opts.parent))
      @_namespace = @_getRandomString()
      @_initStyling()

    constructor: (@el, opts) ->
      @_configure @el, opts
      @events()
      @resize()

    setParentSize: (which, val) ->
      if which is 'width'
        if val?
          @_parentWidth = val
        else
          @_parentWidth = @_$parent.width()

      else if which is 'height'
        if val?
          @_parentHeight = val
        else
          @_parentHeight = @_$parent.height()

      else
        @_parentWidth = @_$parent.width()
        @_parentHeight = @_$parent.height()
      return this

    getParentSize: (which) ->
      if which is 'width'
        return @_parentWidth
      else if which is 'height'
        return @_parentHeight
      else
        return

    _calcCover: ->
      parentWidth = @getParentSize 'width'
      parentHeight = @getParentSize 'height'

      parentRatio = parentHeight / parentWidth

      if @opts.ratio > parentRatio
        @_width = parentWidth
      else
        @_width = parentHeight / @opts.ratio

      @_height = @_width * @opts.ratio

      @_marginTop = -(@_height / 2)
      @_marginLeft = -(@_width / 2)
      return this

    _calcContain: ->
      parentWidth = @getParentSize 'width'
      parentHeight = @getParentSize 'height'

      parentRatio = parentHeight / parentWidth

      if @opts.ratio > parentRatio
        @_height = parentHeight
        @_width = @_height / @opts.ratio
        @_marginTop = -(parentHeight / 2)
        @_marginLeft = -(@_width / 2)
      else
        @_width = parentWidth
        @_height = @_width * @opts.ratio
        @_marginTop = -(@_height / 2)
        @_marginLeft = -(parentWidth / 2)
      return this

    resize: ->
      @setParentSize()
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
        @$el.css 'line-height', "#{@_height}px"
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
