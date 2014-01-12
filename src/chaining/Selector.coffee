erdos  = require('../erdos')
string = require('../util/string')

class Selector  
  ###
  # @constructor Selector
  # Wrap any value in a Selector, allowing to perform chained operations on
  # the value.
  # 
  # All methods available in the erdos.js library can be called upon the selector,
  # and then will be evaluated with the value itself as first argument.
  # The selector can be closed by executing selector.done(), which will return
  # the final value.
  # 
  # The Selector has a number of special functions:
  # - done()             Finalize the chained operation and return the
  # selectors value.
  # - valueOf()          The same as done()
  # - toString()         Returns a string representation of the selectors value.
  # 
  @param {*} [value]
  ###
  constructor: (value) ->
    throw new SyntaxError("Selector constructor must be called with the new operator")  unless this instanceof Selector
    if value instanceof Selector
      @value = value.value
    else
      @value = value
  
  ###
  # Close the selector. Returns the final value.
  # Does the same as method valueOf()
  # @returns {*} value
  ###
  done: ->
    @value
  
  ###
  # Close the selector. Returns the final value.
  # Does the same as method done()
  # @returns {*} value
  ###
  valueOf: ->
    @value

  ###
  # Get a string representation of the value in the selector
  # @returns {String}
  ###
  toString: ->
    string.format @value
  
  ###
  # Create a proxy method for the selector
  # @param {String} name
  # @param {*} value The value or function to be proxied
  ###
  @createProxy: (name, value) ->
    slice = Array.prototype.slice
    if typeof value is "function"
      
      # a function
      Selector::[name] = ->
        args = [@value].concat(slice.call(arguments, 0))
        new Selector(value.apply(this, args))
    else
      # a constant
      Selector::[name] = new Selector(value)

module.exports = (erdos) ->
  ###
  # initialize the Chain prototype with all functions and constants in erdos
  ###
  for prop of erdos
    Selector.createProxy prop, erdos[prop] if erdos.hasOwnProperty(prop) and prop

  exports = Selector
