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
  # Calculate the cotangent of a value. cot(x) is defined as 1 / tan(x)
  # 
  # cot(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Unit | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  ###
  cot = (x) ->
    throw new error.ArgumentsError("cot", arguments.length, 1) unless arguments.length is 1
    return 1 / Math.tan(x) if isNumber(x)

    if isComplex(x)
      den = Math.exp(-4.0 * x.im) - 2.0 * Math.exp(-2.0 * x.im) * Math.cos(2.0 * x.re) + 1.0
      return new Complex(2.0 * Math.exp(-2.0 * x.im) * Math.sin(2.0 * x.re) / den, (Math.exp(-4.0 * x.im) - 1.0) / den)

    if isUnit(x)
      throw new TypeError("Unit in function cot is no angle")  unless x.hasBase(Units.BASE_UNITS.ANGLE)
      return 1 / Math.tan(x.value)

    return collection.deepMap(x, cot)  if isCollection(x)
    return cot(+x)  if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return cot(util.Number.toNumber(x)) if x instanceof BigNumber
    throw new error.UnsupportedTypeError("cot", x)

  erdos.cot = cot
