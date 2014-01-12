util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
collection = require('../../type/Collection')

isCollection = collection.isCollection
isNumber     = util.Number.isNumber
isString     = util.String.isString

###
# Create a boolean or convert a string or number to a boolean.
# In case of a number, true is returned for non-zero numbers, and false in
# case of zero.
# Strings can be 'true' or 'false', or can contain a number.
# When value is a matrix, all elements will be converted to boolean.
# @param {String | Number | Boolean | Array | Matrix} value
# @return {Boolean | Array | Matrix} bool
###
boolean = (value) ->
  throw new error.ArgumentsError("boolean", arguments.length, 0, 1)  unless arguments.length is 1
  return true  if value is "true" or value is true
  return false  if value is "false" or value is false
  return (if value then true else false)  if value instanceof Boolean
  return (value isnt 0)  if isNumber(value)
  return not value.isZero()  if value instanceof BigNumber
  
  if isString(value)
    
    # try case insensitive
    lcase = value.toLowerCase()
    if lcase is "true"
      return true
    else return false  if lcase is "false"
    
    # test whether value is a valid number
    num = Number(value)
    return (num isnt 0)  if value isnt "" and not isNaN(num)
  return collection.deepMap(value, boolean)  if isCollection(value)

  throw new SyntaxError(value.toString() + " is no valid boolean")

module?.exports = boolean
