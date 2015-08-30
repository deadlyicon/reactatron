require 'stdlibjs/Object.clone'
isObject = require 'stdlibjs/isObject'
isFunction = require 'stdlibjs/Function#wrap'
isFunction = require 'stdlibjs/isFunction'
isString = require 'stdlibjs/isString'
isArray = require 'stdlibjs/isArray'

React = require 'react'
BaseMixin = require './BaseMixin'
DataBindingsMixin = require './DataBindingsMixin'
Style = require './Style'
createFactory = require './createFactory'
prepareProps = require './prepareProps'

###


Button = component 'Button',
  render: ->
    …

Button = component 'Button', (props) ->
  …


RedButton = component (props) ->
  props.style.merge
    background: 'red'
  Button(props)


RedButton = Button.withDefaultProps
  style:


RedButton = Button.withStyle 'RedButton',
  background: 'red'


###
createComponent = (name, spec) ->
  return wrapWithPrepareProps(name) if isFunction(name)

  # TODO deprecate this
  if isObject(name)
    throw new Error('this API is deprecated')

  if isFunction(spec)
    render = spec
    spec = {
      render: -> render.call(this, @cloneProps())
    }

  spec.displayName = name
  detectMixins(spec)
  reactClass = React.createClass(spec)
  component = createFactory(reactClass)
  extendComponent(component)
  component.displayName = name
  component

detectMixins = (spec) ->
  spec.mixins ||= []
  spec.mixins.push BaseMixin
  if spec.dataBindings
    spec.mixins.push DataBindingsMixin
  # if spec.style && ?????


extendComponent = (component) ->
  component.withStyle = withStyle
  component.withDefaultProps = withDefaultProps
  component

wrapWithPrepareProps = (component) ->
  extendComponent ->
    component prepareProps.apply(null, arguments)


withStyle = (name, style) ->
  if this.isStyledComponent
    return this.unstyled.withStyle(name, this.style.merge(style))

  component = createComponent name, (props) ->
    props.style = component.style.merge(props.style)
    component.unstyled(props)
  component.style = new Style(style)
  component.unstyled = this
  component.isStyledComponent = true
  component

withDefaultProps = (defaultProps) ->
  parentComponent = this
  wrapWithPrepareProps (props) ->
    props = mergeProps(defaultProps, props)
    parentComponent(props)

mergeStyle = (props, styles...) ->
  props.style = new Style(props.style).update(styles...)

mergeProps = (args...) ->
  mergedStyle = new Style
  mergedProps = {}
  for props in args
    mergedStyle.update(props.style)
    Object.assign(mergedProps, props)
  mergedProps.style = mergedStyle
  mergedProps

createComponent.PropTypes = React.PropTypes
createComponent.mergeStyle = mergeStyle
createComponent.withDefaultProps = (component, props) ->
  withDefaultProps.call(component, props)

module.exports = createComponent
