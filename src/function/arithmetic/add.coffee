module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  error      = require('../../type/Error')
  Matrix     = require('../../type/Matrix')
  Unit       = require('../../type/Unit')
  collection = require('../../type/Collection')

  isBoolean    = util.Boolean.isBoolean
  isNumber     = util.Number.isNumber
  toNumber     = util.Number.toNumber
  toBigNumber  = util.Number.toBigNumber
  isString     = util.String.isString
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Add two values
  # 
  # x + y
  # add(x, y)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex | Unit | String | Array | Matrix} y
  # @return {Number | BigNumber | Complex | Unit | String | Array | Matrix} res
  ###
  add = (x, y) ->
    throw new error.ArgumentsError("add", arguments.length, 2) unless arguments.length is 2

    if isNumber(x)
      if isNumber(y)
        # number + number
        return x + y
      
      # number + complex
      else return new Complex(x + y.re, y.im) if isComplex(y)

    if isComplex(x)
      if isComplex(y)
        # complex + complex
        return new Complex(x.re + y.re, x.im + y.im)
      
      # complex + number
      else return new Complex(x.re + y, x.im) if isNumber(y)

    if isUnit(x)
      if isUnit(y)
        throw new Error("Units do not match")                                           unless x.equalBase(y)
        throw new Error("Unit on left hand side of operator + has an undefined value")  unless x.value?
        throw new Error("Unit on right hand side of operator + has an undefined value") unless y.value?

        res = x.clone()
        res.value += y.value
        res.fixPrefix = false
        return res

    if x instanceof BigNumber   
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0)) if isBoolean(y)

      return x.plus(y) if y instanceof BigNumber
      
      # downgrade to Number
      return add(toNumber(x), y)

    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0)) if isBoolean(x)
      return x.plus(y) if x instanceof BigNumber
      
      # downgrade to Number
      return add(x, toNumber(y))

    return x + y                           if isString(x) or isString(y)
    return collection.deepMap2(x, y, add)  if isCollection(x) or isCollection(y)
    return add(+x, y)                      if isBoolean(x)
    return add(x, +y)                      if isBoolean(y)
    
    throw new error.UnsupportedTypeError("add", x, y)
  
  erdos.add = add
