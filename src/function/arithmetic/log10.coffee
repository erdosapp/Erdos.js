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
  # Calculate the 10-base logarithm of a value
  # 
  # log10(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  ###
  log10 = (x) ->
    throw new error.ArgumentsError("log10", arguments.length, 1)  unless arguments.length is 1
    if isNumber(x)
      if x >= 0
        return Math.log(x) / Math.LN10
      else
        
        # negative value -> complex value computation
        return log10(new Complex(x, 0))
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return log10(util.Number.toNumber(x))  if x instanceof BigNumber
    return new Complex(Math.log(Math.sqrt(x.re * x.re + x.im * x.im)) / Math.LN10, Math.atan2(x.im, x.re) / Math.LN10)  if isComplex(x)
    return collection.deepMap(x, log10)  if isCollection(x)
    return log10(+x)  if isBoolean(x)

    throw new error.UnsupportedTypeError("log10", x)

  erdos.log10 = log10
