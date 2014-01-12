module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  collection = require('../../type/Collection')

  isNumber     = util.Number.isNumber
  toNumber     = util.Number.toNumber
  isBoolean    = util.Boolean.isBoolean
  isInteger    = util.Number.isInteger
  isCollection = collection.isCollection

  ###
  # Calculate the greatest common divisor for two or more values or arrays.
  # 
  # gcd(a, b)
  # gcd(a, b, c, ...)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {... Number | Boolean | Array | Matrix} args    two or more integer numbers
  # @return {Number | Array | Matrix} greatest common divisor
  ###
  gcd = (args) ->
    a = arguments[0]
    b = arguments[1]
    r = undefined
    
    # remainder
    if arguments.length is 2
      
      # two arguments
      if isNumber(a) and isNumber(b)
        throw new Error("Parameters in function gcd must be integer numbers") if not isInteger(a) or not isInteger(b)
        
        # http://en.wikipedia.org/wiki/Euclidean_algorithm
        until b is 0
          r = a % b
          a = b
          b = r

        return (if (a < 0) then -a else a)
      
      # evaluate gcd element wise
      return collection.deepMap2(a, b, gcd) if isCollection(a) or isCollection(b)
      
      # TODO: implement BigNumber support for gcd
      
      # downgrade bignumbers to numbers
      return gcd(toNumber(a), b)  if a instanceof BigNumber
      return gcd(a, toNumber(b))  if b instanceof BigNumber
      return gcd(+a, b)           if isBoolean(a)
      return gcd(a, +b)           if isBoolean(b)
      throw new error.UnsupportedTypeError("gcd", a, b)

    if arguments.length > 2    
      # multiple arguments. Evaluate them iteratively
      i = 1

      while i < arguments.length
        a = gcd(a, arguments[i])
        i++
      return a
    
    # zero or one argument
    throw new SyntaxError("Function gcd expects two or more arguments")

  erdos.gcd = gcd
