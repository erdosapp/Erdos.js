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
	# Round a value towards zero
	# 
	# fix(x)
	# 
	# For matrices, the function is evaluated element wise.
	# 
	# @param {Number | Boolean | Complex | Array | Matrix} x
	# @return {Number | Complex | Array | Matrix} res
	###
	fix = (x) ->
	  throw new error.ArgumentsError("fix", arguments.length, 1)  unless arguments.length is 1
	  return (if (x > 0) then Math.floor(x) else Math.ceil(x)) if isNumber(x)
	  return new Complex((if (x.re > 0) then Math.floor(x.re) else Math.ceil(x.re)), (if (x.im > 0) then Math.floor(x.im) else Math.ceil(x.im)))  if isComplex(x)
	  return (if x.isNegative() then x.ceil() else x.floor()) if x instanceof BigNumber
	  return collection.deepMap(x, fix)  if isCollection(x)
	  return fix(+x) if isBoolean(x)
	  throw new error.UnsupportedTypeError("fix", x)

	erdos.fix = fix
