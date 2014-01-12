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
  # Calculate the least common multiple for two or more values or arrays.
  # 
  # lcm(a, b)
  # lcm(a, b, c, ...)
  # 
  # lcm is defined as:
  # lcm(a, b) = abs(a * b) / gcd(a, b)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {... Number | Boolean | Array | Matrix} args    two or more integer numbers
  # @return {Number | Array | Matrix} least common multiple
  ###
  lcm = (args) ->
    a = arguments[0]
    b = arguments[1]
    t = undefined
    
    if arguments.length is 2
      
      # two arguments
      if isNumber(a) and isNumber(b)
        throw new Error("Parameters in function lcm must be integer numbers") if not isInteger(a) or not isInteger(b)
        return 0  if a is 0 or b is 0
        
        # http://en.wikipedia.org/wiki/Euclidean_algorithm
        # evaluate gcd here inline to reduce overhead
        prod = a * b
        until b is 0
          t = b
          b = a % t
          a = t
        return Math.abs(prod / a)
      
      # evaluate lcm element wise
      return collection.deepMap2(a, b, lcm) if isCollection(a) or isCollection(b)
      return lcm(+a, b) if isBoolean(a)
      return lcm(a, +b) if isBoolean(b)
      
      # TODO: implement BigNumber support for lcm
      
      # downgrade bignumbers to numbers
      return lcm(toNumber(a), b) if a instanceof BigNumber
      return lcm(a, toNumber(b)) if b instanceof BigNumber

      throw new error.UnsupportedTypeError("lcm", a, b)

    if arguments.length > 2  
      # multiple arguments. Evaluate them iteratively
      i = 1

      while i < arguments.length
        a = lcm(a, arguments[i])
        i++

      return a
    
    # zero or one argument
    throw new SyntaxError("Function lcm expects two or more arguments")

  erdos.lcm = lcm
