module.exports = (erdos, settings) ->
  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  isCollection = collection.isCollection

  larger = erdos.larger

  ###
  # Compute the maximum value of a list of values
  # In case of a multi dimensional array, the maximum of the flattened array
  # will be calculated. When dim is provided, the maximum over the selected
  # dimension will be calculated.
  # 
  # max(a, b, c, ...)
  # max(A)
  # max(A, dim)
  # 
  # @param {... *} args  A single matrix or or multiple scalar values
  # @return {*} res
  ###
  max = (args) ->
    throw new SyntaxError("Function max requires one or more parameters (0 provided)") if arguments.length is 0
    if isCollection(args)
      if arguments.length is 1
        
        # max([a, b, c, d, ...])
        _max args
      else if arguments.length is 2
        
        # max([a, b, c, d, ...], dim)
        collection.reduce arguments[0], arguments[1], _getlarger
      else
        throw new SyntaxError("Wrong number of parameters")
    else
      
      # max(a, b, c, d, ...)
      _max arguments

  _getlarger = (x, y) ->
    if larger(x, y)
      x
    else
      y

  ###
  # Recursively calculate the maximum value in an n-dimensional array
  # @param {Array} array
  # @return {Number} max
  # @private
  ###
  _max = (array) ->
    max = null
    collection.deepForEach array, (value) ->
      max = value  if max is null or larger(value, max)

    throw new Error("Cannot calculate max of an empty array")  if max is null
    max

  erdos.max = max
