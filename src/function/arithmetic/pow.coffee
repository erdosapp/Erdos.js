util  = require('../../util/index')
error = require('../../type/Error')

module.exports = (erdos, settings) ->
  BigNumber  = erdos.BigNumber
  Complex    = erdos.Complex
  Matrix     = erdos.Matrix
  collection = erdos.Collection

  array       = util.Array
  isNumber    = util.Number.isNumber
  toNumber    = util.Number.toNumber
  toBigNumber = util.Number.toBigNumber
  isBoolean   = util.Boolean.isBoolean
  isArray     = Array.isArray
  isInteger   = util.Number.isInteger
  isComplex   = Complex.isComplex

  log      = require('./log')(erdos, settings)
  multiply = erdos.multiply
  eye      = erdos.eye
  exp      = require('./exp')(erdos, settings)

  ###
  # Calculates the power of x to y
  # 
  # x ^ y
  # pow(x, y)
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex} y
  # @return {Number | BigNumber | Complex | Array | Matrix} res
  ###
  pow = (x, y) ->
    throw new error.ArgumentsError("pow", arguments.length, 2) unless arguments.length is 2

    if isNumber(x)
      if isNumber(y)
        if isInteger(y) or x >= 0
          
          # real value computation
          return Math.pow(x, y)
        else
          return powComplex(new Complex(x, 0), new Complex(y, 0))
      else return powComplex(new Complex(x, 0), y)  if isComplex(y)

    if isComplex(x)
      if isNumber(y)
        return powComplex(x, new Complex(y, 0))
      else return powComplex(x, y)  if isComplex(y)
    
    # TODO: pow for complex numbers and bignumbers
    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0))  if isBoolean(y)
      return x.pow(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return pow(toNumber(x), y)

    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return x.pow(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return pow(x, toNumber(y))

    if x instanceof Matrix
      return new Matrix(pow(x.valueOf(), y))

    if isArray(x)
      throw new TypeError("For A^b, b must be a positive integer " + "(value is " + y + ")")  if not isNumber(y) or not isInteger(y) or y < 0
      
      # verify that A is a 2 dimensional square matrix
      s = array.size(x)
      throw new Error("For A^b, A must be 2 dimensional " + "(A has " + s.length + " dimensions)")  unless s.length is 2
      throw new Error("For A^b, A must be square " + "(size is " + s[0] + "x" + s[1] + ")")  unless s[0] is s[1]
      if y is 0
        
        # return the identity matrix
        return eye(s[0])
      else
        
        # value > 0
        res = x
        i = 1

        while i < y
          res = multiply(x, res)
          i++
        return res

    return pow(+x, y) if isBoolean(x)
    return pow(x, +y) if isBoolean(y)
    throw new error.UnsupportedTypeError("pow", x, y)

  ###
  # Calculates the power of x to y, x^y, for two complex numbers.
  # @param {Complex} x
  # @param {Complex} y
  # @return {Complex} res
  # @private
  ###
  powComplex = (x, y) ->    
    # complex computation
    # x^y = exp(log(x)*y) = exp((abs(x)+i*arg(x))*y)
    temp1 = log(x)
    temp2 = multiply(temp1, y)
    exp temp2

  erdos.pow = pow
