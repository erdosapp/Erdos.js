module.exports = (erdos, settings) ->
	util  = require('../../util/index')
	error = require('../../type/Error')

	BigNumber  = require('bignumber.js')
	Complex    = require('../../type/Complex')
	collection = require('../../type/Collection')

	number       = util.Number
	isNumber     = util.Number.isNumber
	isBoolean    = util.Boolean.isBoolean
	isComplex    = Complex.isComplex
	isCollection = collection.isCollection
	###
	# Compute the sign of a value.
	# 
	# sign(x)
	# 
	# The sign of a value x is 1 when x > 1, -1 when x < 0, and 0 when x == 0
	# For matrices, the function is evaluated element wise.
	# 
	# @param {Number | BigNumber | Boolean | Complex | Array | Matrix} x
	# @return {Number | BigNumber | Complex | Array | Matrix} res
	###
	sign = (x) ->
	  throw new error.ArgumentsError("sign", arguments.length, 1)  unless arguments.length is 1
	  return number.sign(x)  if isNumber(x)
	  if isComplex(x)
	    abs = Math.sqrt(x.re * x.re + x.im * x.im)
	    return new Complex(x.re / abs, x.im / abs)
	 
	  return new BigNumber(x.cmp(0))  if x instanceof BigNumber
	  return collection.deepMap(x, sign)  if isCollection(x)
	  return number.sign(x)  if isBoolean(x)

	  throw new error.UnsupportedTypeError("sign", x)

	erdos.sign = sign
