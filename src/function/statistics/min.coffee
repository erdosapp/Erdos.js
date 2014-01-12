module.exports = (erdos, settings) ->
  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  isCollection = collection.isCollection

  smaller = erdos.smaller

  ###
  # Compute the minimum value of a list of values.
  # In case of a multi dimensional array, the minimum of the flattened array
  # will be calculated. When dim is provided, the maximum over the selected
  # dimension will be calculated.
  # 
  # min(a, b, c, ...)
  # min(A)
  # min(A, dim)
  # 
  # @param {... *} args  A single matrix or multiple scalar values
  # @return {*} res
  ###
  min = (args) ->
    throw new SyntaxError("Function min requires one or more parameters (0 provided)")  if arguments.length is 0
    if isCollection(args)
      if arguments.length is 1
        # min([a, b, c, d, ...])
        _min args
      else if arguments.length is 2
        
        # min([a, b, c, d, ...], dim)
        collection.reduce arguments[0], arguments[1], _getsmaller
      else
        throw new SyntaxError("Wrong number of parameters")
    else
      
      # min(a, b, c, d, ...)
      _min arguments

  _getsmaller = (x, y) ->
    if smaller(x, y)
      x
    else
      y

  ###
  # Recursively calculate the minimum value in an n-dimensional array
  # @param {Array} array
  # @return {Number} min
  # @private
  ###
  _min = (array) ->
    min = null
    collection.deepForEach array, (value) ->
      min = value if min is null or smaller(value, min)

    throw new Error("Cannot calculate min of an empty array")  if min is null
    min

  erdos.min = min
