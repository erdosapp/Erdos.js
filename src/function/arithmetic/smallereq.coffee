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
  # Check if value a is smaller or equal to b
  # 
  # a <= b
  # smallereq(a, b)
  # 
  # For matrices, the function is evaluated element wise.
  # In case of complex numbers, the absolute values of a and b are compared.
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} y
  # @return {Boolean | Array | Matrix} res
  ###
  smallereq = (x, y) ->
    throw new error.ArgumentsError("smallereq", arguments.length, 2)  unless arguments.length is 2
    return x <= y  if isNumber(x) and isNumber(y)
    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0))  if isBoolean(y)
      return x.lte(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return smallereq(toNumber(x), y)
    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return x.lte(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return smallereq(x, toNumber(y))

    if (isUnit(x)) and (isUnit(y))
      throw new Error("Cannot compare units with different base")  unless x.equalBase(y)
      return x.value <= y.value

    return x <= y  if isString(x) or isString(y)
    return collection.deepMap2(x, y, smallereq)  if isCollection(x) or isCollection(y)
    return smallereq(+x, y)  if isBoolean(x)
    return smallereq(x, +y)  if isBoolean(y)

    throw new TypeError("No ordering relation is defined for complex numbers")  if isComplex(x) or isComplex(y)
    throw new error.UnsupportedTypeError("smallereq", x, y)

  erdos.smallereq = smallereq
