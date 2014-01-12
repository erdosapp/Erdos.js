module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isCollection = collection.isCollection

  ###
  # Calculate the exponent of a value
  # 
  # exp(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  ###
  exp = (x) ->
    throw new error.ArgumentsError("exp", arguments.length, 1) unless arguments.length is 1
    return Math.exp(x) if isNumber(x)
    
    if isComplex(x)
      r = Math.exp(x.re)
      return new Complex(r * Math.cos(x.im), r * Math.sin(x.im))
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return exp(util.Number.toNumber(x)) if x instanceof BigNumber
    return collection.deepMap(x, exp)   if isCollection(x)
    return Math.exp(x)                  if isBoolean(x)

    throw new error.UnsupportedTypeError("exp", x)

  erdos.exp = exp
