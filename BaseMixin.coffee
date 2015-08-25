React = require 'react'

module.exports =

  getInitialState: ->
    @app = @context.app || @props.app
    @_dataBindings = if @getDataBindings
      @getDataBindings()
    else
      []
    @_getData()
    {}

  contextTypes:
    app: React.PropTypes.object.isRequired

  _getData: ->
    @data = {}
    for key in @_dataBindings
      @data[key] = @app.get(key)

  rerender: ->
    @_getData()
    @forceUpdate()

  componentDidMount: ->
    for key in @_dataBindings
      @app.sub "store:change:#{key}", @rerender

  componentWillUnmount: ->
    for key in @_dataBindings
      @app.unsub "store:change:#{key}", @rerender


  cloneProps: ->
    props = Object.clone(@props)
    props.style = Styles(props.style)
    props.className = Classnames(props.className)
