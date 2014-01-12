util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
Complex    = require('../../type/Complex')
Matrix     = require('../../type/Matrix')
collection = require('../../type/Collection')

isNumber     = util.Number.isNumber
isBoolean    = util.Boolean.isBoolean
isComplex    = Complex.isComplex
isCollection = collection.isCollection

module.exports = (erdos, settings) ->
	abs = (x) ->
	  throw new error.ArgumentsError("abs", arguments.length, 1) unless arguments.length is 1

	  return Math.abs(x)                          if isNumber(x)
	  return Math.sqrt(x.re * x.re + x.im * x.im) if isComplex(x)
	  return x.abs()                              if x instanceof BigNumber
	  return collection.deepMap(x, abs)           if isCollection(x)
	  return Math.abs(x)                          if isBoolean(x)

	  throw new error.UnsupportedTypeError("abs", x)

  erdos.abs = abs
