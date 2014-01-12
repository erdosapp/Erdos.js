module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  object       = util.Object
  array        = util.Array
  isNumber     = util.Number.isNumber
  isInteger    = util.Number.isInteger
  isCollection = collection.isCollection

  ###
  # Concatenate two or more matrices
  # Usage:
  # erdos.concat(A, B, C, ...)
  # erdos.concat(A, B, C, ..., dim)
  # 
  # Where the optional dim is the zero-based number of the dimension to be
  # concatenated.
  # 
  # @param {... Array | Matrix} args
  # @return {Array | Matrix} res
  ###
  concat = (args) ->
    i        = undefined
    len      = arguments.length
    dim      = -1 # zero-based dimension
    prevDim  = undefined
    asMatrix = false
    matrices = [] # contains multi dimensional arrays

    i = 0
    while i < len
      arg = arguments[i]
      
      # test whether we need to return a Matrix (if not we return an Array)
      asMatrix = true if arg instanceof Matrix
      if (i is len - 1) and isNumber(arg)
        
        # last argument contains the dimension on which to concatenate
        prevDim = dim
        dim = arg
        throw new TypeError("Dimension number must be a positive integer " + "(dim = " + dim + ")")  if not isInteger(dim) or dim < 0
        throw new RangeError("Dimension out of range " + "(" + dim + " > " + prevDim + ")")  if i > 0 and dim > prevDim
      else if isCollection(arg)
        
        # this is a matrix or array
        matrix = object.clone(arg).valueOf()
        size = array.size(arg.valueOf())
        matrices[i] = matrix
        prevDim = dim
        dim = size.length - 1
        
        # verify whether each of the matrices has the same number of dimensions
        throw new RangeError("Dimension mismatch " + "(" + prevDim + " != " + dim + ")")  if i > 0 and dim isnt prevDim
      else
        throw new error.UnsupportedTypeError("concat", arg)
      i++

    throw new SyntaxError("At least one matrix expected") if matrices.length is 0

    res = matrices.shift()
    res = _concat(res, matrices.shift(), dim, 0)  while matrices.length
    (if asMatrix then new Matrix(res) else res)

  ###
  # Recursively concatenate two matrices.
  # The contents of the matrices is not cloned.
  # @param {Array} a             Multi dimensional array
  # @param {Array} b             Multi dimensional array
  # @param {Number} concatDim    The dimension on which to concatenate (zero-based)
  # @param {Number} dim          The current dim (zero-based)
  # @return {Array} c            The concatenated matrix
  # @private
  ###
  _concat = (a, b, concatDim, dim) ->
    if dim < concatDim
      
      # recurse into next dimension
      throw new Error("Dimensions mismatch (" + a.length + " != " + b.length + ")")  unless a.length is b.length
      c = []
      i = 0

      while i < a.length
        c[i] = _concat(a[i], b[i], concatDim, dim + 1)
        i++
      c
    else
      # concatenate this dimension
      a.concat b

  erdos.concat = concat
