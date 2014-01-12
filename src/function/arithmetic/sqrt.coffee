module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isCollection = collection.isCollection

  ###
  # Calculate the square root of a value
  # 
  # sqrt(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  ###
  sqrt = (x) ->
    throw new error.ArgumentsError("sqrt", arguments.length, 1)  unless arguments.length is 1
    if isNumber(x)
      if x >= 0
        return Math.sqrt(x)
      else
        return sqrt(new Complex(x, 0))
    if isComplex(x)
      r = Math.sqrt(x.re * x.re + x.im * x.im)
      if x.im >= 0
        return new Complex(0.5 * Math.sqrt(2.0 * (r + x.re)), 0.5 * Math.sqrt(2.0 * (r - x.re)))
      else
        return new Complex(0.5 * Math.sqrt(2.0 * (r + x.re)), -0.5 * Math.sqrt(2.0 * (r - x.re)))
    return x.sqrt()  if x instanceof BigNumber
    return collection.deepMap(x, sqrt)  if isCollection(x)
    return sqrt(+x)  if isBoolean(x)
    throw new error.UnsupportedTypeError("sqrt", x)

  erdos.sqrt = sqrt
