module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Unit       = require('../../type/Unit')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Inverse the sign of a value.
  # 
  # -x
  # unary(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
  # @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
  ###
  unary = (x) ->
    throw new error.ArgumentsError("unary", arguments.length, 1)  unless arguments.length is 1
    return -x  if isNumber(x)
    return new Complex(-x.re, -x.im)  if isComplex(x)
    return x.neg()  if x instanceof BigNumber

    if isUnit(x)
      res = x.clone()
      res.value = -x.value
      return res

    return collection.deepMap(x, unary) if isCollection(x)
    return -x                           if isBoolean(x)
    
    throw new error.UnsupportedTypeError("unary", x)

  erdos.unary = unary
