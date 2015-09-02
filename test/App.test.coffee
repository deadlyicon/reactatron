require './helper'

App = require '../App'

describe 'App', ->

  app = data = null
  beforeEach ->
    app = new App
      window: new FakeWindow

    app.document = {body: {}}
    app.store.data = data = {}
    app.render = new CallLogger

  it 'pub sub', (done) ->

    loginCounter = new Counter

    app.sub 'login', loginCounter

    expect(loginCounter.value).to.be(0)
    app.pub 'login'
    expect(loginCounter.value).to.be(0)
    setTimeout ->
      expect(loginCounter.value).to.be(1)
      app.unsub 'login', loginCounter
      app.pub 'login'
      expect(loginCounter.value).to.be(1)
      setTimeout ->
        expect(loginCounter.value).to.be(1)
        done()


  it 'store', (done) ->

    current_user = { name: 'Thomas' }

    events = []
    app.sub '*', (event, payload) ->
      events.push [event, payload]

    app.set current_user: current_user
    expect( app.get('current_user') ).to.eql(current_user)
    expect( app.get('current_user') ).to.not.be(current_user)
    expect( events ).to.eql([])

    setTimeout ->
      expect( events ).to.eql([
        [ 'store:change:current_user', 'current_user' ],
      ])
      done()


  describe '#render', ->
    # we need to pull in the react test tools for this one
    xit 'should render the rootComponent', ->
      app.render()
      expect(app.rootComponent).to.be.eql({})


  describe '#stop', ->
    it 'should delete rootComponent and DOMNode'


  describe '#registerPlugin', ->
    it 'should app its self to the app property of its target and then add it to the plugins array'
