module.exports = (erdos, settings) ->
	util  = require('../../util/index')
	error = require('../../type/Error')

	BigNumber  = require('bignumber.js')
	Complex    = require('../../type/Complex')
	collection = require('../../type/Collection')

	isNumber     = util.Number.isNumber
	isBoolean    = util.Boolean.isBoolean
	isComplex    = Complex.isComplex
	isCollection = collection.isCollection

	multiply = require('./multiply')(erdos, settings)

	###
	# Compute the square of a value
	# 
	# x .* x
	# square(x)
	# 
	# For matrices, the function is evaluated element wise.
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Array | Matrix} x
	# @return {Number | BigNumber | Complex | Array | Matrix} res
	###
	square = (x) ->
	  throw new error.ArgumentsError("square", arguments.length, 1)  unless arguments.length is 1
	  return x * x  if isNumber(x)
	  return multiply(x, x)  if isComplex(x)
	  return x.times(x)  if x instanceof BigNumber
	  return collection.deepMap(x, square)  if isCollection(x)
	  return x * x  if isBoolean(x)
	  throw new error.UnsupportedTypeError("square", x)

	erdos.square = square
