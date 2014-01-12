module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Unit       = require('../../type/Unit')
  Units      = require('../../type/Units')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Calculate the cosine of a value
  # 
  # cos(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Unit | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  # 
  # @see http://erdosworld.wolfram.com/Cosine.html
  ###
  cos = (x) ->
    throw new error.ArgumentsError("cos", arguments.length, 1)  unless arguments.length is 1
    return Math.cos(x)  if isNumber(x)
    
    # cos(z) = (exp(iz) + exp(-iz)) / 2
    return new Complex(0.5 * Math.cos(x.re) * (Math.exp(-x.im) + Math.exp(x.im)), 0.5 * Math.sin(x.re) * (Math.exp(-x.im) - Math.exp(x.im)))  if isComplex(x)
    if isUnit(x)
      throw new TypeError("Unit in function cos is no angle")  unless x.hasBase(Units.BASE_UNITS.ANGLE)
      return Math.cos(x.value)
    return collection.deepMap(x, cos)  if isCollection(x)
    return Math.cos(x)  if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return cos(util.Number.toNumber(x))  if x instanceof BigNumber
    throw new error.UnsupportedTypeError("cos", x)

  erdos.cos = cos
