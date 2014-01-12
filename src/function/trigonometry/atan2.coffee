module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  collection = require('../../type/Collection')

  toNumber     = util.Number.toNumber
  isNumber     = util.Number.isNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isCollection = collection.isCollection

  ###
  # Computes the principal value of the arc tangent of y/x in radians
  # 
  # atan2(y, x)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Number | Boolean | Complex | Array | Matrix} y
  # @param {Number | Boolean | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} res
  # 
  # @see http://erdosworld.wolfram.com/InverseTangent.html
  ###
  atan2 = (y, x) ->
    throw new error.ArgumentsError("atan2", arguments.length, 2)  unless arguments.length is 2
    if isNumber(y)
      return Math.atan2(y, x) if isNumber(x)
    
    # TODO: support for complex computation of atan2
    #       else if (isComplex(x)) {
    #       return Math.atan2(y.re, x.re);
    #       }
    #       
    else return Math.atan2(y.re, x) if isNumber(x) and isComplex(y)
    
    # TODO: support for complex computation of atan2
    #       else if (isComplex(x)) {
    #       return Math.atan2(y.re, x.re);
    #       }
    #       
    return collection.deepMap2(y, x, atan2) if isCollection(y) or isCollection(x)
    return atan2(+y, x)                     if isBoolean(y)
    return atan2(y, +x)                     if isBoolean(x)
    
    # TODO: implement bignumber support
    return atan2(toNumber(y), x) if y instanceof BigNumber
    return atan2(y, toNumber(x)) if x instanceof BigNumber

    throw new error.UnsupportedTypeError("atan2", y, x)

  erdos.atan2 = atan2
