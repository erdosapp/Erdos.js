util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
Complex    = require('../../type/Complex')
collection = require('../../type/Collection')

isNumber     = util.Number.isNumber
isBoolean    = util.Boolean.isBoolean
isCollection = collection.isCollection
isComplex    = Complex.isComplex

###
# Compute the argument of a complex value.
# If x = a + bi, the argument is computed as atan2(b, a).
# 
# arg(x)
# 
# For matrices, the function is evaluated element wise.
# 
# @param {Number | Complex | Array | Matrix | Boolean} x
# @return {Number | Array | Matrix} res
###
arg = (x) ->
  throw new error.ArgumentsError("arg", arguments.length, 1) unless arguments.length is 1
  return Math.atan2(0, x)  if isNumber(x)
  return Math.atan2(x.im, x.re)  if isComplex(x)
  return collection.deepMap(x, arg)  if isCollection(x)
  return arg(+x)  if isBoolean(x)
  
  # downgrade to Number
  # TODO: implement BigNumber support
  return arg(util.Number.toNumber(x))  if x instanceof BigNumber
  throw new error.UnsupportedTypeError("arg", x)

module?.exports = arg
