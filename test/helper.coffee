require 'stdlibjs/Object.assign'

clear = require('clear')

global.expect  = expect = require 'expect.js'
global.inspect = expect.stringify

before ->
  clear()


global.assert = (result, message) ->
  if result
    return
  error = new Error(message())
  throw error
  return

global.FakeWindow = ->
  {
    location:
      pathname: '/'
      search: ''
    addEventListener: new CallLogger
    removeEventListener: new CallLogger
  }

global.CallLogger = ->

  callLogger = ->
    callLogger.calls.push [].slice.call(arguments)
    callLogger.callCount = callLogger.calls.length
    return

  callLogger.reset = ->
    callLogger.calls = []
    callLogger.callCount = 0
    return

  callLogger.reset()
  callLogger

global.Counter = ->

  counter = ->
    counter.value++
    return

  counter.value = 0
  counter





###


React Helpers


###




React        = require '../React'
ReactElement = require 'react/lib/ReactElement'
expect       = require 'expect.js'

inspect   = expect.stringify
Assertion = expect.Assertion

Object.assign(global, React.addons.TestUtils)


Assertion.prototype.aReactElement = ->
  element = @obj
  @assert isElement(element), -> "expected #{inspect(element)} to be a React element"


Assertion.prototype.aValidReactElement = ->
  element = @obj
  expect(element).to.be.aReactElement()

  typeoOfType = typeof element.type
  @assert 'string' == typeoOfType || 'function' == typeoOfType,
    -> "expected #{inspect(element.type)} to be a string or a function"


Assertion.prototype.render = (html) ->
  element = @obj
  expect( element                 ).to.be.aReactElement()
  expect( html                    ).to.be.a('string')
  expect( renderToString(element) ).to.eql(html)


Assertion.prototype.aComponentClass = ->
  ComponentClass = @obj
  expect(ComponentClass).to.be.a('function')

  typeoOfType = typeof ComponentClass.type
  @assert 'string' ==  typeoOfType || 'function' == typeoOfType,
    -> "expected ComponentClass.type to be a string or a function. Got: #{inspect(ComponentClass)}"

  @assert ComponentClass.prototype.constructor == ComponentClass,
    -> "expected ComponentClass.prototype.constructor to be ComponentClass. Got: #{inspect(ComponentClass.prototype.constructor)}"

  @assert ComponentClass.type == ComponentClass,
    -> "expected ComponentClass.type to be ComponentClass. Got: #{inspect(ComponentClass.type)}"

Assertion.prototype.aValidComponentClass = ->
  ComponentClass = @obj
  expect(ComponentClass).to.be.aComponentClass()

  element = React.createElement(ComponentClass, {p:1, children:'X'}, 'A', 'B')
  expect(element).to.be.aValidReactElement()
  expect(element._store).to.eql
    props:         {p:1, children: ['A','B']}
    originalProps: {p:1, children: ['A','B']}

  element = React.createElement(ComponentClass, {p:1, children:'X'})
  expect(element._store).to.eql
    props:         {p:1, children: 'X'}
    originalProps: {p:1, children: 'X'}

  instance = new ComponentClass({p:1},{c:1})
  expect(instance.props  ).to.eql p: 1
  expect(instance.context).to.eql c: 1
  assert ('state' of instance), -> "expected ComponentClass instance to have state prop"
  expect(instance).to.be.a(ComponentClass)

  element = ComponentClass()
  expect(element).to.be.aValidReactElement()









global.withContext = (context, render) ->
  # context.app ||= {}
  childContextTypes = {}
  for key of context
    childContextTypes[key] = React.PropTypes.any

  ContextProvider = React.createClass
    displayName: 'ContextProvider',
    childContextTypes: childContextTypes
    getChildContext: -> context
    render: -> render()

  React.createElement(ContextProvider)


global.renderToString = (element) ->
  React.renderToStaticMarkup(element)









