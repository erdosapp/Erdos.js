module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber = require('bignumber.js')

  toNumber  = util.Number.toNumber
  isNumber  = util.Number.isNumber
  isBoolean = util.Boolean.isBoolean
  isInteger = util.Number.isInteger

  ###
  # Calculate the extended greatest common divisor for two values.
  # 
  # xgcd(a, b)
  # 
  # @param {Number | Boolean} a  An integer number
  # @param {Number | Boolean} b  An integer number
  # @return {Array}              An array containing 3 integers [div, m, n]
  # where div = gcd(a, b) and a*m + b*n = div
  # 
  # @see http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
  ###
  xgcd = (a, b) ->
    if arguments.length is 2
      
      # two arguments
      if isNumber(a) and isNumber(b)
        throw new Error("Parameters in function xgcd must be integer numbers")  if not isInteger(a) or not isInteger(b)
        return _xgcd(a, b)
      
      # TODO: implement BigNumber support for xgcd
      
      # downgrade bignumbers to numbers
      return xgcd(toNumber(a), b)  if a instanceof BigNumber
      return xgcd(a, toNumber(b))  if b instanceof BigNumber
      return xgcd(+a, b)  if isBoolean(a)
      return xgcd(a, +b)  if isBoolean(b)
      throw new error.UnsupportedTypeError("xgcd", a, b)
    
    # zero or one argument
    throw new SyntaxError("Function xgcd expects two arguments")

  ###
  # Calculate xgcd for two numbers
  # @param {Number} a
  # @param {Number} b
  # @private
  ###
  _xgcd = (a, b) ->
    
    #*
    # source: http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
    t = undefined # used to swap two variables
    q = undefined
    r = undefined
    # quotient
    # remainder
    x = 0
    lastx = 1
    y = 1
    lasty = 0
    while b
      q = Math.floor(a / b)
      r = a % b
      t = x
      x = lastx - q * x
      lastx = t
      t = y
      y = lasty - q * y
      lasty = t
      a = b
      b = r
    if a < 0
      [-a, (if a then -lastx else 0), -lasty]
    else
      [a, (if a then lastx else 0), lasty]

  erdos.xgcd = xgcd
