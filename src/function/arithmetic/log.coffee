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

  divide = require('./divide')(erdos, settings)

  ###
  # Calculate the logarithm of a value
  # 
  # log(x)
  # log(x, base)
  # 
  # base is optional. If not provided, the natural logarithm of x is calculated.
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @param {Number | Boolean | Complex} [base]
  # @return {Number | Complex | Array | Matrix} res
  ###
  log = (x, base) ->
    if arguments.length is 1
      
      # calculate natural logarithm, log(x)
      if isNumber(x)
        if x >= 0
          return Math.log(x)
        else
          
          # negative value -> complex value computation
          return log(new Complex(x, 0))

      return new Complex(Math.log(Math.sqrt(x.re * x.re + x.im * x.im)), Math.atan2(x.im, x.re)) if isComplex(x)
      
      # TODO: implement BigNumber support
      # downgrade to Number
      return log(util.Number.toNumber(x)) if x instanceof BigNumber
      return collection.deepMap(x, log)   if isCollection(x)
      return log(+x)                      if isBoolean(x)

      throw new error.UnsupportedTypeError("log", x)
    else if arguments.length is 2
      # calculate logarithm for a specified base, log(x, base)
      divide log(x), log(base)
    else
      throw new error.ArgumentsError("log", arguments.length, 1, 2)

  erdos.log = log
