module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Matrix     = require('../../type/Matrix')
  Unit       = require('../../type/Unit')
  collection = require('../../type/Collection')

  array       = util.Array
  isNumber    = util.Number.isNumber
  toNumber    = util.Number.toNumber
  toBigNumber = util.Number.toBigNumber
  isBoolean   = util.Boolean.isBoolean
  isComplex   = Complex.isComplex
  isArray     = Array.isArray
  isUnit      = Unit.isUnit

  add = erdos.add

  ###
  # Multiply two values.
  # 
  # x * y
  # multiply(x, y)
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} y
  # @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
  ###
  multiply = (x, y) ->
    throw new error.ArgumentsError("multiply", arguments.length, 2) unless arguments.length is 2

    if isNumber(x)
      if isNumber(y)
        
        # number * number
        return x * y
      else if isComplex(y)
        # number * complex
        return _multiplyComplex(new Complex(x, 0), y)
      else if isUnit(y)
        res = y.clone()
        res.value *= x
        return res

    if isComplex(x)
      if isNumber(y)
        
        # complex * number
        return _multiplyComplex(x, new Complex(y, 0))
      
      # complex * complex
      else return _multiplyComplex(x, y) if isComplex(y)

    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0))  if isBoolean(y)
      return x.times(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return multiply(toNumber(x), y)

    if y instanceof BigNumber
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return x.times(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return multiply(x, toNumber(y))

    if isUnit(x)
      if isNumber(y)
        res = x.clone()
        res.value *= y
        return res

    if isArray(x)
      if isArray(y)
        
        # array * array
        sizeX = array.size(x)
        sizeY = array.size(y)

        if sizeX.length is 1
          if sizeY.length is 1
            
            # vector * vector
            throw new RangeError("Dimensions mismatch in multiplication. " + "Length of A must match length of B " + "(A is " + sizeX[0] + ", B is " + sizeY[0] + sizeX[0] + " != " + sizeY[0] + ")")  unless sizeX[0] is sizeY[0]
            return _multiplyVectorVector(x, y)
          else if sizeY.length is 2
            
            # vector * matrix
            throw new RangeError("Dimensions mismatch in multiplication. " + "Length of A must match rows of B " + "(A is " + sizeX[0] + ", B is " + sizeY[0] + "x" + sizeY[1] + ", " + sizeX[0] + " != " + sizeY[0] + ")")  unless sizeX[0] is sizeY[0]
            return _multiplyVectorMatrix(x, y)
          else
            throw new Error("Can only multiply a 1 or 2 dimensional matrix " + "(B has " + sizeY.length + " dimensions)")
        else if sizeX.length is 2
          if sizeY.length is 1
            
            # matrix * vector
            throw new RangeError("Dimensions mismatch in multiplication. " + "Columns of A must match length of B " + "(A is " + sizeX[0] + "x" + sizeX[0] + ", B is " + sizeY[0] + ", " + sizeX[1] + " != " + sizeY[0] + ")")  unless sizeX[1] is sizeY[0]
            return _multiplyMatrixVector(x, y)
          else if sizeY.length is 2
            
            # matrix * matrix
            throw new RangeError("Dimensions mismatch in multiplication. " + "Columns of A must match rows of B " + "(A is " + sizeX[0] + "x" + sizeX[1] + ", B is " + sizeY[0] + "x" + sizeY[1] + ", " + sizeX[1] + " != " + sizeY[0] + ")")  unless sizeX[1] is sizeY[0]
            return _multiplyMatrixMatrix(x, y)
          else
            throw new Error("Can only multiply a 1 or 2 dimensional matrix " + "(B has " + sizeY.length + " dimensions)")
        else
          throw new Error("Can only multiply a 1 or 2 dimensional matrix " + "(A has " + sizeX.length + " dimensions)")
      else if y instanceof Matrix
        
        # array * matrix
        return new Matrix(multiply(x, y.valueOf()))
      else
        
        # array * scalar
        return collection.deepMap2(x, y, multiply)

    if x instanceof Matrix
      if y instanceof Matrix
        
        # matrix * matrix
        return new Matrix(multiply(x.valueOf(), y.valueOf()))
      else
        
        # matrix * array
        # matrix * scalar
        return new Matrix(multiply(x.valueOf(), y))
    if isArray(y)
      
      # scalar * array
      return collection.deepMap2(x, y, multiply)
    
    # scalar * matrix
    else return new Matrix(collection.deepMap2(x, y.valueOf(), multiply)) if y instanceof Matrix

    return multiply(+x, y) if isBoolean(x)
    return multiply(x, +y) if isBoolean(y)

    throw new error.UnsupportedTypeError("multiply", x, y)

  ###
  # Multiply two 2-dimensional matrices.
  # The size of the matrices is not validated.
  # @param {Array} x   A 2d matrix
  # @param {Array} y   A 2d matrix
  # @return {Array} result
  # @private
  ###
  _multiplyMatrixMatrix = (x, y) ->
    
    # TODO: performance of matrix multiplication can be improved
    res = []
    rows = x.length
    cols = y[0].length
    num = x[0].length
    r = 0

    while r < rows
      res[r] = []
      c = 0

      while c < cols
        result = null
        n = 0

        while n < num
          p = multiply(x[r][n], y[n][c])
          result = (if (result is null) then p else add(result, p))
          n++
        res[r][c] = result
        c++
      r++
    res

  ###
  # Multiply a vector with a 2-dimensional matrix
  # The size of the matrices is not validated.
  # @param {Array} x   A vector
  # @param {Array} y   A 2d matrix
  # @return {Array} result
  # @private
  ###
  _multiplyVectorMatrix = (x, y) ->
    
    # TODO: performance of matrix multiplication can be improved
    res  = []
    rows = y.length
    cols = y[0].length
    c    = 0

    while c < cols
      result = null
      r = 0

      while r < rows
        p = multiply(x[r], y[r][c])
        result = (if (r is 0) then p else add(result, p))
        r++
      res[c] = result
      c++
    res

  ###
  # Multiply a 2-dimensional matrix with a vector
  # The size of the matrices is not validated.
  # @param {Array} x   A 2d matrix
  # @param {Array} y   A vector
  # @return {Array} result
  # @private
  ###
  _multiplyMatrixVector = (x, y) ->
    
    # TODO: performance of matrix multiplication can be improved
    res  = []
    rows = x.length
    cols = x[0].length
    r    = 0

    while r < rows
      result = null
      c = 0

      while c < cols
        p = multiply(x[r][c], y[c])
        result = (if (c is 0) then p else add(result, p))
        c++
      res[r] = result
      r++
    res

  ###
  # Multiply two vectors, calculate the dot product
  # The size of the matrices is not validated.
  # @param {Array} x   A vector
  # @param {Array} y   A vector
  # @return {Number} dotProduct
  # @private
  ###
  _multiplyVectorVector = (x, y) ->
    
    # TODO: performance of matrix multiplication can be improved
    len = x.length
    dot = null
    if len
      dot = 0
      i = 0
      ii = x.length

      while i < ii
        dot = add(dot, multiply(x[i], y[i]))
        i++
    dot

  ###
  # Multiply two complex numbers. x * y or multiply(x, y)
  # @param {Complex} x
  # @param {Complex} y
  # @return {Complex | Number} res
  # @private
  ###
  _multiplyComplex = (x, y) ->
    
    # Note: we test whether x or y are pure real or pure complex,
    # to prevent unnecessary NaN values. For example, Infinity*i should
    # result in Infinity*i, and not in NaN+Infinity*i
    if x.im is 0
      
      # x is pure real
      if y.im is 0
        
        # y is pure real
        new Complex(x.re * y.re, 0)
      else if y.re is 0
        
        # y is pure complex
        new Complex(0, x.re * y.im)
      else
        
        # y has a real and complex part
        new Complex(x.re * y.re, x.re * y.im)
    else if x.re is 0
      
      # x is pure complex
      if y.im is 0
        
        # y is pure real
        new Complex(0, x.im * y.re)
      else if y.re is 0
        
        # y is pure complex
        new Complex(-x.im * y.im, 0)
      else
        
        # y has a real and complex part
        new Complex(-x.im * y.im, x.im * y.re)
    else
      # x has a real and complex part
      if y.im is 0
        
        # y is pure real
        new Complex(x.re * y.re, x.im * y.re)
      else if y.re is 0
        # y is pure complex
        new Complex(-x.im * y.im, x.re * y.im)
      else
        # y has a real and complex part
        new Complex(x.re * y.re - x.im * y.im, x.re * y.im + x.im * y.re)

  erdos.multiply = multiply
