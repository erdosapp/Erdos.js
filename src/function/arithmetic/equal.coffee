module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Unit       = require('../../type/Unit')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  toNumber     = util.Number.toNumber
  toBigNumber  = util.Number.toBigNumber
  isBoolean    = util.Boolean.isBoolean
  isString     = util.String.isString
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Check if value x equals y,
  # 
  # x == y
  # equal(x, y)
  # 
  # For matrices, the function is evaluated element wise.
  # In case of complex numbers, x.re must equal y.re, and x.im must equal y.im.
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} y
  # @return {Boolean | Array | Matrix} res
  ###
  equal = (x, y) ->
    throw new error.ArgumentsError("equal", arguments.length, 2)  unless arguments.length is 2
    if isNumber(x)
      if isNumber(y)
        return x is y
      else return (x is y.re) and (y.im is 0) if isComplex(y)

    if isComplex(x)
      if isNumber(y)
        return (x.re is y) and (x.im is 0)
      else return (x.re is y.re) and (x.im is y.im) if isComplex(y)

    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0)) if isBoolean(y)
      return x.eq(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return equal(toNumber(x), y)

    if y instanceof BigNumber   
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0)) if isBoolean(x)

      return x.eq(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return equal(x, toNumber(y))

    if (isUnit(x)) and (isUnit(y))
      throw new Error("Cannot compare units with different base") unless x.equalBase(y)
      return x.value is y.value

    return `x == y`                         if isString(x) or isString(y)
    return collection.deepMap2(x, y, equal) if isCollection(x) or isCollection(y)
    return equal(+x, y)                     if isBoolean(x)
    return equal(x, +y)                     if isBoolean(y)

    throw new error.UnsupportedTypeError("equal", x, y)

  erdos.equal = equal
