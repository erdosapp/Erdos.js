module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  toNumber     = util.Number.toNumber
  toBigNumber  = util.Number.toBigNumber
  isBoolean    = util.Boolean.isBoolean
  isCollection = collection.isCollection

  ###
  # Calculates the modulus, the remainder of an integer division.
  # 
  # x % y
  # mod(x, y)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param  {Number | BigNumber | Boolean | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Array | Matrix} y
  # @return {Number | BigNumber | Array | Matrix} res
  ###
  mod = (x, y) ->
    throw new error.ArgumentsError("mod", arguments.length, 2) unless arguments.length is 2
    
    # see http://functions.wolfram.com/IntegerFunctions/Mod/
    
    # number % number
    return _mod(x, y) if isNumber(y) and isNumber(x)

    if x instanceof BigNumber   
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0)) if isBoolean(y)

      return x.mod(y) if y instanceof BigNumber
      
      # downgrade to Number
      return mod(toNumber(x), y)

    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0))  if isBoolean(x)
      return x.mod(y)  if x instanceof BigNumber
      
      # downgrade to Number
      return mod(x, toNumber(y))
    
    # TODO: implement mod for complex values
    return collection.deepMap2(x, y, mod) if isCollection(x) or isCollection(y)
    return mod(+x, y)                     if isBoolean(x)
    return mod(x, +y)                     if isBoolean(y)

    throw new error.UnsupportedTypeError("mod", x, y)

  ###
  # Calculate the modulus of two numbers
  # @param {Number} x
  # @param {Number} y
  # @returns {number} res
  # @private
  ###
  _mod = (x, y) ->
    if y > 0
      if x > 0
        x % y
      else if x is 0
        0
      else # x < 0
        x - y * Math.floor(x / y)
    else if y is 0
      x
    else # y < 0
      # TODO: implement mod for a negative divisor
      throw new Error("Cannot calculate mod for a negative divisor")

  erdos.mod = mod
