module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Matrix     = require('../../type/Matrix')
  Unit       = require('../../type/Unit')
  collection = require('../../type/Collection')

  toNumber     = util.Number.toNumber
  toBigNumber  = util.Number.toBigNumber
  isBoolean    = util.Boolean.isBoolean
  isNumber     = util.Number.isNumber
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Subtract two values
  # 
  # x - y
  # subtract(x, y)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} y
  # @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
  ###
  subtract = (x, y) ->
    throw new error.ArgumentsError("subtract", arguments.length, 2)  unless arguments.length is 2
    if isNumber(x)
      if isNumber(y)
        
        # number - number
        return x - y
      
      # number - complex
      else return new Complex(x - y.re, -y.im)  if isComplex(y)
    else if isComplex(x)
      if isNumber(y)
        
        # complex - number
        return new Complex(x.re - y, x.im)
      
      # complex - complex
      else return new Complex(x.re - y.re, x.im - y.im)  if isComplex(y)
    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0))  if isBoolean(y)
      return x.minus(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return subtract(toNumber(x), y)
    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return x.minus(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return subtract(x, toNumber(y))
    if isUnit(x)
      if isUnit(y)
        throw new Error("Units do not match")  unless x.equalBase(y)
        throw new Error("Unit on left hand side of operator - has an undefined value")  unless x.value?
        throw new Error("Unit on right hand side of operator - has an undefined value")  unless y.value?
        res = x.clone()
        res.value -= y.value
        res.fixPrefix = false
        return res
    return collection.deepMap2(x, y, subtract)  if isCollection(x) or isCollection(y)
    return subtract(+x, y)  if isBoolean(x)
    return subtract(x, +y)  if isBoolean(y)
    throw new error.UnsupportedTypeError("subtract", x, y)

  erdos.subtract = subtract
