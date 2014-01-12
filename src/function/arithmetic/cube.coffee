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
	# Compute the cube of a value
	# 
	# x .* x .* x
	# cube(x)
	# 
	# For matrices, the function is evaluated element wise.
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Array | Matrix} x
	# @return {Number | BigNumber | Complex | Array | Matrix} res
	###
	cube = (x) ->
	  throw new error.ArgumentsError("cube", arguments.length, 1) unless arguments.length is 1

	  return x * x * x                    if isNumber(x)
	  return multiply(multiply(x, x), x)  if isComplex(x)
	  return x.times(x).times(x)          if x instanceof BigNumber
	  return collection.deepMap(x, cube)  if isCollection(x)
	  return cube(+x)                     if isBoolean(x)

	  throw new error.UnsupportedTypeError("cube", x)

	erdos.cube = cube
