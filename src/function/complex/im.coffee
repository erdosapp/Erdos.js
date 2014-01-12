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
# Get the imaginary part of a complex number.
# 
# im(x)
# 
# For matrices, the function is evaluated element wise.
# 
# @param {Number | BigNumber | Complex | Array | Matrix | Boolean} x
# @return {Number | BigNumber | Array | Matrix} im
###
im = (x) ->
  throw new error.ArgumentsError("im", arguments.length, 1) unless arguments.length is 1

  return 0                         if isNumber(x)
  return new BigNumber(0)          if x instanceof BigNumber
  return x.im                      if isComplex(x)
  return collection.deepMap(x, im) if isCollection(x)
  return 0                         if isBoolean(x)
  
  # return 0 for all non-complex values
  0

module?.exports = im
