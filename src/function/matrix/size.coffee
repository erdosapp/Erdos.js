module.exports = (erdos, settings) ->
	util  = require('../../util/index')
	error = require('../../type/Error')

	BigNumber = require('bignumber.js')
	Complex   = require('../../type/Complex')
	Unit      = require('../../type/Unit')
	Matrix    = require('../../type/Matrix')

	array      = util.Array
	isNumber   = util.Number.isNumber
	isBoolean  = util.Boolean.isBoolean
	isString   = util.String.isString
	isComplex  = Complex.isComplex
	isUnit     = Unit.isUnit

	###
	# Calculate the size of a matrix or scalar
	# 
	# size(x)
	# 
	# @param {Boolean | Number | Complex | Unit | String | Array | Matrix} x
	# @return {Array | Matrix} res
	###
	size = (x) ->
	  throw new error.ArgumentsError("size", arguments.length, 1)  unless arguments.length is 1
	  asArray = (settings.matrix is "array")
	  return (if asArray then [] else new Matrix([]))  if isNumber(x) or isComplex(x) or isUnit(x) or isBoolean(x) or not x? or x instanceof BigNumber
	  return (if asArray then [x.length] else new Matrix([x.length]))  if isString(x)
	  return array.size(x)  if Array.isArray(x)
	  return new Matrix(x.size())  if x instanceof Matrix
	  throw new error.UnsupportedTypeError("size", x)
  
  erdos.size = size
