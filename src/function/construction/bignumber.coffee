util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
collection = require('../../type/Collection')

isCollection = collection.isCollection
isNumber     = util.Number.isNumber
isString     = util.String.isString
isBoolean    = util.Boolean.isBoolean

# extend BigNumber with a function clone
if typeof BigNumber::clone isnt "function"
  
  ###
  Clone a bignumber
  @return {BigNumber} clone
  ###
  BigNumber::clone = clone = ->
    new BigNumber(this)

###
# Create a big number, which can store numbers with higher precision than
# a JavaScript Number.
# When value is a matrix, all elements will be converted to bignumber.
# 
# @param {Number | String | Array | Matrix} [value]  Value for the big number,
# 0 by default.
###
bignumber = (value) ->
  throw new error.ArgumentsError("bignumber", arguments.length, 0, 1)  if arguments.length > 1
  return new BigNumber(value)  if (value instanceof BigNumber) or isNumber(value) or isString(value)
  return new BigNumber(+value)  if isBoolean(value)
  return collection.deepMap(value, bignumber)  if isCollection(value)
  return new BigNumber(0)  if arguments.length is 0
  throw new error.UnsupportedTypeError("bignumber", value)

module?.exports = bignumber
