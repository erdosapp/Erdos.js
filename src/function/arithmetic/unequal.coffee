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
  # Check if value x unequals y, x != y
  # In case of complex numbers, x.re must unequal y.re, or x.im must unequal y.im
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} y
  # @return {Boolean | Array | Matrix} res
  ###
  unequal = (x, y) ->
    throw new error.ArgumentsError("unequal", arguments.length, 2)  unless arguments.length is 2
    if isNumber(x)
      if isNumber(y)
        return x isnt y
      else return (x isnt y.re) or (y.im isnt 0)  if isComplex(y)

    if isComplex(x)
      if isNumber(y)
        return (x.re isnt y) or (x.im isnt 0)
      else return (x.re isnt y.re) or (x.im isnt y.im)  if isComplex(y)

    if x instanceof BigNumber  
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0))  if isBoolean(y)
      return not x.eq(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return unequal(toNumber(x), y)

    if y instanceof BigNumber    
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return not x.eq(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return unequal(x, toNumber(y))

    if (isUnit(x)) and (isUnit(y))
      throw new Error("Cannot compare units with different base")  unless x.equalBase(y)
      return x.value isnt y.value

    return `x != y`  if isString(x) or isString(y)
    return collection.deepMap2(x, y, unequal)  if isCollection(x) or isCollection(y)
    return unequal(+x, y)  if isBoolean(x)
    return unequal(x, +y)  if isBoolean(y)
    throw new error.UnsupportedTypeError("unequal", x, y)

  erdos.unequal = unequal
