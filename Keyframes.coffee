hyphenateStyleName = require 'react/lib/hyphenateStyleName'

module.exports = class Keyframes
  constructor: (name, spec) ->
    @name = name
    @spec = spec

  toRule: ->
    css = "@keyframes #{@name} {\n"
    for frame, style of @spec
      css += "  #{frame} {\n"
      for name, value of style
        name = hyphenateStyleName(name)
        css += "    -webkit-#{name}: #{value};\n"
        css += "    #{name}: #{value};\n"
      css += "  }\n"
    css += "}\n"
    css





# bounce = new Keyframes 'bounce',
#   'from, 20%, 53%, 80%, to':
#     animationTimingFunction: 'cubic-bezier(0.215, 0.610, 0.355, 1.000)'
#     transform: 'translate3d(0,0,0)'

#   '40%, 43%':
#     animationTimingFunction: 'cubic-bezier(0.755, 0.050, 0.855, 0.060)'
#     transform: 'translate3d(0, -30px, 0)'

#   '70%':
#     animationTimingFunction: 'cubic-bezier(0.755, 0.050, 0.855, 0.060)'
#     transform: 'translate3d(0, -15px, 0)'

#   '90%':
#     transform: 'translate3d(0,-4px,0)'

