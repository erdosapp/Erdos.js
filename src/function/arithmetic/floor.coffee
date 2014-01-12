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

	###
	# Round a value towards minus infinity
	# 
	# floor(x)
	# 
	# For matrices, the function is evaluated element wise.
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Array | Matrix} x
	# @return {Number | BigNumber | Complex | Array | Matrix} res
	###
	floor = (x) ->
	  throw new error.ArgumentsError("floor", arguments.length, 1) unless arguments.length is 1
	  return Math.floor(x)                                   if isNumber(x)
	  return new Complex(Math.floor(x.re), Math.floor(x.im)) if isComplex(x)
	  return x.floor()                                       if x instanceof BigNumber
	  return collection.deepMap(x, floor)                    if isCollection(x)
	  return floor(+x)                                       if isBoolean(x)

	  throw new error.UnsupportedTypeError("floor", x)

	erdos.floor = floor
