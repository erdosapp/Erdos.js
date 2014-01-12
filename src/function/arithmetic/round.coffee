module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  isInteger    = util.Number.isInteger
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isCollection = collection.isCollection

  ###
  # Round a value towards the nearest integer
  # 
  # round(x)
  # round(x, n)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Array} [n] number of decimals (by default n=0)
  # @return {Number | BigNumber | Complex | Array | Matrix} res
  ###
  round = (x, n) ->
    throw new error.ArgumentsError("round", arguments.length, 1, 2)  if arguments.length isnt 1 and arguments.length isnt 2
    if n is undefined
      
      # round (x)
      return Math.round(x)  if isNumber(x)
      return new Complex(Math.round(x.re), Math.round(x.im))  if isComplex(x)
      return x.round()  if x instanceof BigNumber
      return collection.deepMap(x, round)  if isCollection(x)
      return Math.round(x)  if isBoolean(x)
      throw new error.UnsupportedTypeError("round", x)
    else
      
      # round (x, n)
      n = parseFloat(n.valueOf())  if n instanceof BigNumber
      throw new TypeError("Number of decimals in function round must be an integer")  if not isNumber(n) or not isInteger(n)
      throw new Error("Number of decimals in function round must be in te range of 0-9")  if n < 0 or n > 9
      return roundNumber(x, n)  if isNumber(x)
      return new Complex(roundNumber(x.re, n), roundNumber(x.im, n))  if isComplex(x)
      return x.round(n)  if isNumber(n)  if x instanceof BigNumber
      return collection.deepMap2(x, n, round)  if isCollection(x) or isCollection(n)
      return round(+x, n)  if isBoolean(x)
      return round(x, +n)  if isBoolean(n)
      throw new error.UnsupportedTypeError("round", x, n)

  ###
  # round a number to the given number of decimals, or to zero if decimals is
  # not provided
  # @param {Number} value
  # @param {Number} [decimals]  number of decimals, between 0 and 15 (0 by default)
  # @return {Number} roundedValue
  ###
  roundNumber = (value, decimals) ->
    if decimals
      p = Math.pow(10, decimals)
      Math.round(value * p) / p
    else
      Math.round value

  erdos.round = round
