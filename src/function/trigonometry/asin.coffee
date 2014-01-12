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

  sqrt = erdos.sqrt
  log  = erdos.log

  ###
  # Calculate the inverse sine of a value
  # 
  # asin(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  # 
  # @see http://erdosworld.wolfram.com/InverseSine.html
  ###
  asin = (x) ->
    throw new error.ArgumentsError("asin", arguments.length, 1)  unless arguments.length is 1
    if isNumber(x)
      if x >= -1 and x <= 1
        return Math.asin(x)
      else
        return asin(new Complex(x, 0))
    if isComplex(x)
      
      # asin(z) = -i*log(iz + sqrt(1-z^2))
      re = x.re
      im = x.im
      temp1 = new Complex(im * im - re * re + 1.0, -2.0 * re * im)
      temp2 = sqrt(temp1)
      temp3 = undefined
      if temp2 instanceof Complex
        temp3 = new Complex(temp2.re - im, temp2.im + re)
      else
        temp3 = new Complex(temp2 - im, re)
      temp4 = log(temp3)
      if temp4 instanceof Complex
        return new Complex(temp4.im, -temp4.re)
      else
        return new Complex(0, -temp4)
    return collection.deepMap(x, asin)  if isCollection(x)
    return Math.asin(x)  if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return asin(util.Number.toNumber(x))  if x instanceof BigNumber
    throw new error.UnsupportedTypeError("asin", x)

  erdos.asin = asin
