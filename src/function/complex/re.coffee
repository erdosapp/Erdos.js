util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
Complex    = require('../../type/Complex')
collection = require('../../type/Collection')

object = util.Object

isNumber     = util.Number.isNumber
isBoolean    = util.Boolean.isBoolean
isCollection = collection.isCollection
isComplex    = Complex.isComplex

###
# Get the real part of a complex number.
# 
# re(x)
# 
# For matrices, the function is evaluated element wise.
# 
# @param {Number | BigNumber | Complex | Array | Matrix | Boolean} x
# @return {Number | BigNumber | Array | Matrix} re
###
re = (x) ->
  throw new error.ArgumentsError("re", arguments.length, 1) unless arguments.length is 1

  return x                         if isNumber(x)
  return new BigNumber(x)          if x instanceof BigNumber
  return x.re                      if isComplex(x)
  return collection.deepMap(x, re) if isCollection(x)
  return +x                        if isBoolean(x)
  
  # return a clone of the value itself for all non-complex values
  object.clone x

module?.exports = re
