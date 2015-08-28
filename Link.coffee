require 'stdlibjs/Object.clone'
React = require 'react'
component = require './component'

module.exports = component 'Link',


  location: ->
    @app.locationFor(@props.path, @props.params)

  onClick: (event) ->
    if event?
      return if event.shiftKey || event.metaKey || event.ctrlKey

    if @props.onClick
      @props.onClick(event)
      return

    return if event? && event.defaultPrevented
    event.preventDefault()

    if @props.path? || @props.params?
      @app.setLocation @location()
      return

  defaultStyle:
    cursor: 'pointer'
    color: 'inherit'
    textDecoration: 'none'

  render: ->
    props = @cloneProps()
    props.onClick = @onClick
    props.href = @location() if props.path? || props.params?
    props.href ||= ''
    React.createElement('a', props)
