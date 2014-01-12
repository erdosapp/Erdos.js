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

  log = erdos.log

  ###
  # Calculate the inverse tangent of a value
  # 
  # atan(x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  # 
  # @see http://erdosworld.wolfram.com/InverseTangent.html
  ###
  atan = (x) ->
    throw new error.ArgumentsError("atan", arguments.length, 1) unless arguments.length is 1
    return Math.atan(x)  if isNumber(x)
    
    if isComplex(x)
      # atan(z) = 1/2 * i * (ln(1-iz) - ln(1+iz))
      re    = x.re
      im    = x.im
      den   = re * re + (1.0 - im) * (1.0 - im)
      temp1 = new Complex((1.0 - im * im - re * re) / den, (-2.0 * re) / den)
      temp2 = log(temp1)

      if temp2 instanceof Complex
        return new Complex(-0.5 * temp2.im, 0.5 * temp2.re)
      else
        return new Complex(0, 0.5 * temp2)

    return collection.deepMap(x, atan) if isCollection(x)
    return Math.atan(x)                if isBoolean(x)
    
    # TODO: implement BigNumber support
    # downgrade to Number
    return atan(util.Number.toNumber(x))  if x instanceof BigNumber
    throw new error.UnsupportedTypeError("atan", x)

  erdos.atan = atan
