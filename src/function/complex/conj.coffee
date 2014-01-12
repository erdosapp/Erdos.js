util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
Complex    = require('../../type/Complex')
collection = require('../../type/Collection')

object       = util.Object
isNumber     = util.Number.isNumber
isBoolean    = util.Boolean.isBoolean
isCollection = collection.isCollection
isComplex    = Complex.isComplex

###
# Compute the complex conjugate of a complex value.
# If x = a+bi, the complex conjugate is a-bi.
# 
# conj(x)
# 
# For matrices, the function is evaluated element wise.
# 
# @param {Number | BigNumber | Complex | Array | Matrix | Boolean} x
# @return {Number | BigNumber | Complex | Array | Matrix} res
###
conj = (x) ->
  throw new error.ArgumentsError("conj", arguments.length, 1) unless arguments.length is 1

  return x                           if isNumber(x)
  return new BigNumber(x)            if x instanceof BigNumber
  return new Complex(x.re, -x.im)    if isComplex(x)
  return collection.deepMap(x, conj) if isCollection(x)
  return +x                          if isBoolean(x)
  
  # return a clone of the value for non-complex values
  object.clone x

module?.exports = conj
