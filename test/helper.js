React = require('react/addons')

expect = require('expect.js')
inspect = expect.stringify
Assertion = expect.Assertion
TestUtils = React.addons.TestUtils


isElement                           = TestUtils.isElement
isElementOfType                     = TestUtils.isElementOfType
isDOMComponent                      = TestUtils.isDOMComponent
isDOMComponentElement               = TestUtils.isDOMComponentElement
isCompositeComponent                = TestUtils.isCompositeComponent
isCompositeComponentWithType        = TestUtils.isCompositeComponentWithType
isCompositeComponentElement         = TestUtils.isCompositeComponentElement
isCompositeComponentElementWithType = TestUtils.isCompositeComponentElementWithType
findAllInRenderedTree               = TestUtils.findAllInRenderedTree


Assertion.prototype.aReactElement = function(){
  var component = this.obj;
  this.assert(
      isElement(component)
    , function(){ return 'expected ' + inspect(component) + ' to be a React element' }
    , function(){ return 'expected ' + inspect(component) + ' to not be a React element' });
}

Assertion.prototype.render = function(html) {
  expect(this.obj).to.be.a('function');
  expect(html).to.be.a('string');
  expect( renderToString({}, this.obj) ).to.eql(html);
};


Assertion.prototype.aComponent = function() {
  expect(this.obj).to.be.a('function');
  expect(
    'string' == typeof this.obj.type ||
    'object' == typeof this.obj.type
  ).to.be(true)
};

// window = this
// location = {
//   pathname: '/',
//   search: '',
// }
// document = {}
// document.body = {'BODY': true}


FakeWindow = function(){
  return {
    location: {
      pathname: '/',
      search: '',
    },
    addEventListener: new CallLogger,
    removeEventListener: new CallLogger,
  };
};


CallLogger = function(){
  var callLogger = function(){
    callLogger.calls.push([].slice.call(arguments));
    callLogger.callCount = callLogger.calls.length;
  };
  callLogger.reset = function(){
    callLogger.calls = [];
    callLogger.callCount = 0;
  };
  callLogger.reset();

  return callLogger;
};


Counter = function(){
  var counter = function(){
    counter.value++;
  }
  counter.value = 0;
  return counter;
};


renderToString = function(app, render) {
  return React.renderToStaticMarkup(
    ContextWrapper({app: app, render: render})
  );
};

// renderComponent = function(app, component, props, children){
//   args = [].alice.call(arguments, 2);
//   return React.renderToStaticMarkup(
//     ContextWrapper({app: app}, Component.call(null, args))
//   );
// };


ContextWrapper = React.createFactory(React.createClass({
  displayName: 'ContextWrapper',
  childContextTypes: {
    app: React.PropTypes.object,
  },
  getChildContext: function(){
    return {
      app: this.props.app
    };
  },
  render: function(){
    return this.props.render()
  }

}))
