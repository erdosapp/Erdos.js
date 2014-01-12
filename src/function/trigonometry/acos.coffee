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
  # Calculate the inverse cosine of a value
  # 
  # acos(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  # 
  # @see http://erdosworld.wolfram.com/InverseCosine.html
  ###
  acos = (x) ->
    throw new error.ArgumentsError("acos", arguments.length, 1)  unless arguments.length is 1
    if isNumber(x)
      if x >= -1 and x <= 1
        return Math.acos(x)
      else
        return acos(new Complex(x, 0))
    if isComplex(x)
      
      # acos(z) = 0.5*pi + i*log(iz + sqrt(1-z^2))
      temp1 = new Complex(x.im * x.im - x.re * x.re + 1.0, -2.0 * x.re * x.im)
      temp2 = sqrt(temp1)
      temp3 = undefined
      if temp2 instanceof Complex
        temp3 = new Complex(temp2.re - x.im, temp2.im + x.re)
      else
        temp3 = new Complex(temp2 - x.im, x.re)
      temp4 = log(temp3)
      
      # 0.5*pi = 1.5707963267948966192313216916398
      if temp4 instanceof Complex
        return new Complex(1.57079632679489661923 - temp4.im, temp4.re)
      else
        return new Complex(1.57079632679489661923, temp4)

    return collection.deepMap(x, acos) if isCollection(x)
    return Math.acos(x)                if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return acos(util.Number.toNumber(x)) if x instanceof BigNumber

    throw new error.UnsupportedTypeError("acos", x)

  erdos.acos = acos
