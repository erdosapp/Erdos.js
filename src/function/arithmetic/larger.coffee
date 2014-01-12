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
  # Check if value x is larger y
  # 
  # x > y
  # larger(x, y)
  # 
  # For matrices, the function is evaluated element wise.
  # In case of complex numbers, the absolute values of a and b are compared.
  # 
  # @param  {Number | BigNumber | Boolean | Unit | String | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Unit | String | Array | Matrix} y
  # @return {Boolean | Array | Matrix} res
  ###
  larger = (x, y) ->
    throw new error.ArgumentsError("larger", arguments.length, 2) unless arguments.length is 2
    return x > y  if isNumber(x) and isNumber(y)
    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0))  if isBoolean(y)
      return x.gt(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return larger(toNumber(x), y)
      
    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return x.gt(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return larger(x, toNumber(y))

    if (isUnit(x)) and (isUnit(y))
      throw new Error("Cannot compare units with different base")  unless x.equalBase(y)
      return x.value > y.value

    return x > y                             if isString(x) or isString(y)
    return collection.deepMap2(x, y, larger) if isCollection(x) or isCollection(y)
    return larger(+x, y)                     if isBoolean(x)
    return larger(x, +y)                     if isBoolean(y)

    throw new TypeError("No ordering relation is defined for complex numbers") if isComplex(x) or isComplex(y)
    throw new error.UnsupportedTypeError("larger", x, y)

  erdos.larger = larger
