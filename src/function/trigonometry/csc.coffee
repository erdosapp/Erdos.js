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
  # Calculate the cosecant of a value, csc(x) = 1/sin(x)
  # 
  # csc(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Unit | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  ###
  csc = (x) ->
    throw new error.ArgumentsError("csc", arguments.length, 1) unless arguments.length is 1
    return 1 / Math.sin(x) if isNumber(x)

    if isComplex(x)
      # csc(z) = 1/sin(z) = (2i) / (exp(iz) - exp(-iz))
      den = 0.25 * (Math.exp(-2.0 * x.im) + Math.exp(2.0 * x.im)) - 0.5 * Math.cos(2.0 * x.re)
      return new Complex(0.5 * Math.sin(x.re) * (Math.exp(-x.im) + Math.exp(x.im)) / den, 0.5 * Math.cos(x.re) * (Math.exp(-x.im) - Math.exp(x.im)) / den)
    
    if isUnit(x)
      throw new TypeError("Unit in function csc is no angle")  unless x.hasBase(Units.BASE_UNITS.ANGLE)
      return 1 / Math.sin(x.value)
    
    return collection.deepMap(x, csc)  if isCollection(x)
    return csc(+x)  if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return csc(util.Number.toNumber(x))  if x instanceof BigNumber
    throw new error.UnsupportedTypeError("csc", x)

  erdos.csc = csc
