util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
collection = require('../../type/Collection')

isNumber     = util.Number.isNumber
isBoolean    = util.Boolean.isBoolean
isInteger    = util.Number.isInteger
isCollection = collection.isCollection

###
# Compute the factorial of a value
# 
# x!
# factorial(x)
# 
# Factorial only supports an integer value as argument.
# For matrices, the function is evaluated element wise.
# 
# @Param {Number | BigNumber | Array | Matrix} x
# @return {Number | BigNumber | Array | Matrix} res
###
factorial = (x) ->
  value = undefined
  res = undefined
  throw new error.ArgumentsError("factorial", arguments.length, 1)  unless arguments.length is 1
  if isNumber(x)
    throw new TypeError("Positive integer value expected in function factorial")  if not isInteger(x) or x < 0
    value = x - 1
    res = x
    while value > 1
      res *= value
      value--
    res = 1  if res is 0 # 0! is per definition 1
    return res
  if x instanceof BigNumber
    throw new TypeError("Positive integer value expected in function factorial")  if not x.round().equals(x) or x.lt(0)
    one = new BigNumber(1)
    value = x.minus(one)
    res = x
    while value.gt(one)
      res = res.times(value)
      value = value.minus(one)
    res = one  if res.equals(0) # 0! is per definition 1
    return res
  return 1  if isBoolean(x) # factorial(1) = 1, factorial(0) = 1
  return collection.deepMap(x, factorial)  if isCollection(x)
  throw new error.UnsupportedTypeError("factorial", x)

module?.exports = factorial
