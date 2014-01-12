module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Unit       = require('../../type/Unit')
  Units      = require('../../type/Units')
  collection = require('../../type/Collection')

  toNumber     = util.Number.toNumber
  isNumber     = util.Number.isNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Calculate the tangent of a value
  # 
  # tan(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Unit | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  # 
  # @see http://erdosworld.wolfram.com/Tangent.html
  ###
  tan = (x) ->
    throw new error.ArgumentsError("tan", arguments.length, 1)  unless arguments.length is 1
    return Math.tan(x)  if isNumber(x)

    if isComplex(x)
      den = Math.exp(-4.0 * x.im) + 2.0 * Math.exp(-2.0 * x.im) * Math.cos(2.0 * x.re) + 1.0
      return new Complex(2.0 * Math.exp(-2.0 * x.im) * Math.sin(2.0 * x.re) / den, (1.0 - Math.exp(-4.0 * x.im)) / den)
    
    if isUnit(x)
      throw new TypeError("Unit in function tan is no angle")  unless x.hasBase(Units.BASE_UNITS.ANGLE)
      return Math.tan(x.value)
    
    return collection.deepMap(x, tan)  if isCollection(x)
    return Math.tan(x)  if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return tan(util.Number.toNumber(x))  if x instanceof BigNumber
    throw new error.UnsupportedTypeError("tan", x)

  erdos.tan = tan
