module.exports = (erdos, settings) ->
	util  = require('../../util/index')
	error = require('../../type/Error')

	BigNumber  = require('bignumber.js')
	Complex    = require('../../type/Complex')
	collection = require('../../type/Collection')

	isNumber     = util.Number.isNumber
	isBoolean    = util.Boolean.isBoolean
	isCollection = collection.isCollection
	isComplex    = Complex.isComplex

	###
	# Round a value towards plus infinity
	# 
	# ceil(x)
	# 
	# For matrices, the function is evaluated element wise.
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Array | Matrix} x
	# @return {Number | BigNumber | Complex | Array | Matrix} res
	###
	ceil = (x) ->
	  throw new error.ArgumentsError("ceil", arguments.length, 1) unless arguments.length is 1
	  
	  return Math.ceil(x)                                  if isNumber(x)
	  return new Complex(Math.ceil(x.re), Math.ceil(x.im)) if isComplex(x)
	  return x.ceil()                                      if x instanceof BigNumber
	  return collection.deepMap(x, ceil)                   if isCollection(x)
	  return Math.ceil(x)                                  if isBoolean(x)
	  
	  throw new error.UnsupportedTypeError("ceil", x)

	erdos.ceil = ceil
