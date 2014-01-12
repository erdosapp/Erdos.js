module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Complex    = require('../../type/Complex')
  Matrix     = require('../../type/Matrix')
  Unit       = require('../../type/Unit')
  collection = require('../../type/Collection')
   
  isNumber     = util.Number.isNumber
  toNumber     = util.Number.toNumber
  toBigNumber  = util.Number.toBigNumber
  isBoolean    = util.Boolean.isBoolean
  isComplex    = Complex.isComplex
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  inv      = require("../matrix/inv")(erdos, erdos.settings)
  multiply = require("./multiply")(erdos, erdos.settings)

  ###
  # Divide two values.
  # 
  # x / y
  # divide(x, y)
  # 
  # @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
  # @param  {Number | BigNumber | Boolean | Complex} y
  # @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
  ###
  divide = (x, y) ->
    throw new error.ArgumentsError("divide", arguments.length, 2)  unless arguments.length is 2
    if isNumber(x)
      if isNumber(y)
        # number / number
        return x / y
      
      # number / complex
      else 
        return _divideComplex(new Complex(x, 0), y) if isComplex(y)

    if isComplex(x)
      if isComplex(y)
        
        # complex / complex
        return _divideComplex(x, y)
      
      # complex / number
      else return _divideComplex(x, new Complex(y, 0)) if isNumber(y)

    if x instanceof BigNumber
      
      # try to convert to big number
      if isNumber(y)
        y = toBigNumber(y)
      else y = new BigNumber((if y then 1 else 0)) if isBoolean(y)
      return x.div(y)  if y instanceof BigNumber
      
      # downgrade to Number
      return divide(toNumber(x), y)

    if y instanceof BigNumber
      
      # try to convert to big number
      if isNumber(x)
        x = toBigNumber(x)
      else x = new BigNumber((if x then 1 else 0)) if isBoolean(x)
      return x.div(y) if x instanceof BigNumber
      
      # downgrade to Number
      return divide(x, toNumber(y))

    if isUnit(x)
      if isNumber(y)
        res = x.clone()
        res.value /= y
        return res

    if isCollection(x)
      if isCollection(y)
        # TODO: implement matrix right division using pseudo inverse
        # http://www.erdosworks.nl/help/matlab/ref/mrdivide.html
        # http://www.gnu.org/software/octave/doc/interpreter/Arithmetic-Ops.html
        # http://stackoverflow.com/questions/12263932/how-does-gnu-octave-matrix-division-work-getting-unexpected-behaviour
        return multiply(x, inv(y))
      else
        
        # matrix / scalar
        return collection.deepMap2(x, y, divide)
    
    # TODO: implement matrix right division using pseudo inverse
    return multiply(x, inv(y)) if isCollection(y)
    return divide(+x, y)       if isBoolean(x)
    return divide(x, +y)       if isBoolean(y)

    throw new error.UnsupportedTypeError("divide", x, y)

  ###
  # Divide two complex numbers. x / y or divide(x, y)
  # @param {Complex} x
  # @param {Complex} y
  # @return {Complex} res
  # @private
  ###
  _divideComplex = (x, y) ->
    den = y.re * y.re + y.im * y.im
    unless den is 0
      new Complex((x.re * y.re + x.im * y.im) / den, (x.im * y.re - x.re * y.im) / den)
    else
      # both y.re and y.im are zero
      new Complex((if (x.re isnt 0) then (x.re / 0) else 0), (if (x.im isnt 0) then (x.im / 0) else 0))

  erdos.divide = divide
