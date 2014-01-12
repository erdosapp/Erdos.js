Matrix     = require('../../type/Matrix')
collection = require('../../type/Collection')

isCollection = collection.isCollection

module.exports = (erdos, settings) ->
  add    = erdos.add
  divide = erdos.divide
  size   = erdos.size

  ###
  # Compute the mean value of a list of values
  # In case of a multi dimensional array, the mean of the flattened array
  # will be calculated. When dim is provided, the maximum over the selected
  # dimension will be calculated.
  # 
  # mean(a, b, c, ...)
  # mean(A)
  # mean(A, dim)
  # 
  # @param {... *} args  A single matrix or or multiple scalar values
  # @return {*} res
  ###
  mean = (args) ->
    throw new SyntaxError("Function mean requires one or more parameters (0 provided)")  if arguments.length is 0
    if isCollection(args)
      if arguments.length is 1
        
        # mean([a, b, c, d, ...])
        _mean args
      else if arguments.length is 2
        
        # mean([a, b, c, d, ...], dim)
        _nmean arguments[0], arguments[1]
      else
        throw new SyntaxError("Wrong number of parameters")
    else
      
      # mean(a, b, c, d, ...)
      _mean arguments

  ###
  # Calculate the mean value in an n-dimensional array, returning a
  # n-1 dimensional array
  # @param {Array} array
  # @param {Number} dim
  # @return {Number} mean
  # @private
  ###
  _nmean = (array, dim) ->
    sum = undefined
    sum = collection.reduce(array, dim, add)
    divide sum, size(array)[dim]

  ###
  # Recursively calculate the mean value in an n-dimensional array
  # @param {Array} array
  # @return {Number} mean
  # @private
  ###
  _mean = (array) ->
    sum = 0
    num = 0
    collection.deepForEach array, (value) ->
      sum = add(sum, value)
      num++

    throw new Error("Cannot calculate mean of an empty array") if num is 0
    divide sum, num

  erdos.mean = mean
