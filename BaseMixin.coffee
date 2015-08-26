React = require 'react'
ReactatronApp = require './App'
Style = require './Style'
require 'stdlibjs/Array#excludes'

module.exports =

  contextTypes:
    # app: React.PropTypes.instanceOf(ReactatronApp).isRequired
    app: React.PropTypes.object.isRequired

  rerender: ->
    @forceUpdate()

  ### DATA BINDINGS MIXIN ###

  get: (key) ->
    if @_dataBindings.excludes(key)
      @_dataBindings.push(key)
      @app.sub "store:change:#{key}", @rerender

    @app.get(key)

  getInitialState: ->
    @_dataBindings = []
    @app = @context.app || @props.app
    {}

  componentWillUnmount: ->
    for key in @_dataBindings
      @app.unsub "store:change:#{key}", @rerender

  ### / DATA BINDINGS MIXIN ###


  ### STYLES MIXIN ###

  cloneProps: ->
    props = Object.clone(@props)
    props.style = new Style(@defaultStyle)
      .merge(props.style)
      .merge(@styleFromProps())
      .merge(@enforcedStyle)
    props

  styleFromProps: ->
    style = {}
    style.flexGrow   = @props.grow      if @props.grow?
    style.flexShrink = @props.shrink    if @props.shrink?
    style.minWidth   = @props.minWidth  if @props.minWidth?
    style.overflowY  = @props.overflowY if @props.overflowY?
    style.overflowX  = @props.overflowX if @props.overflowX?
    style.overflow   = @props.overflow  if @props.overflow?
    style


  ### / STYLES MIXIN ###
