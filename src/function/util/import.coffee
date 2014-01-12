util  = require('../../util/index')

Complex = require('../../type/Complex')
Unit    = require('../../type/Unit')

isNumber  = util.Number.isNumber
isString  = util.String.isString
isComplex = Complex.isComplex
isUnit    = Unit.isUnit

module.exports = (erdos, settings) ->
  ###
  # Import functions from an object or a file
  # @param {function | String | Object} object
  # @param {Object} [options]        Available options:
  # {Boolean} override
  # If true, existing functions will be
  # overwritten. False by default.
  # {Boolean} wrap
  # If true (default), the functions will
  # be wrapped in a wrapper function which
  # converts data types like Matrix to
  # primitive data types like Array.
  # The wrapper is needed when extending
  # erdos.js with libraries which do not
  # support the erdos.js data types.
  ###

  # TODO: return status information
  importt = (object, options) ->
    name = undefined
    opts =
      override: false
      wrap: true

    util.Object.extend opts, options if options and options instanceof Object

    if isString(object)
      # a string with a filename
      if typeof (require) isnt "undefined"
        
        # load the file using require
        _module = require(object)
        erdos_import _module
      else
        throw new Error("Cannot load file: require not available.")
    else if isSupportedType(object)
      
      # a single function
      name = object.name
      if name
        _import name, object, opts  if opts.override or erdos[name] is undefined
      else
        throw new Error("Cannot import an unnamed function or object")
    else if object instanceof Object
      
      # a map with functions
      for name of object
        if object.hasOwnProperty(name)
          value = object[name]
          if isSupportedType(value)
            _import name, value, opts
          else
            erdos_import value
            
  ###
  # Add a property to the erdos namespace and create a chain proxy for it.
  # @param {String} name
  # @param {*} value
  # @param {Object} options  See import for a description of the options
  # @private
  ###
  _import = (name, value, options) ->
    if options.override or erdos[name] is undefined
      
      # add to erdos namespace
      if options.wrap and typeof value is "function"
        
        # create a wrapper around the function
        erdos[name] = ->
          args = []
          i = 0
          len = arguments.length

          while i < len
            args[i] = arguments[i].valueOf()
            i++
          value.apply erdos, args
      else
        
        # just create a link to the function or value
        erdos[name] = value
      
      # create a proxy for the Selector
      erdos.chaining.Selector.createProxy name, value

  ###
  # Check whether given object is a supported type
  # @param object
  # @return {Boolean}
  # @private
  ###
  isSupportedType = (object) ->
    (typeof object is "function") or isNumber(object) or isString(object) or isComplex(object) or isUnit(object)

    # TODO: add boolean?

  exports = importt
