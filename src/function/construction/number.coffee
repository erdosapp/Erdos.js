util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
collection = require('../../type/Collection')

isCollection = collection.isCollection
toNumber     = util.Number.toNumber

###
# Create a number or convert a string to a number.
# When value is a matrix, all elements will be converted to number.
# @param {String | Number | Boolean | Array | Matrix} [value]
# @return {Number | Array | Matrix} num
###
number = (value) ->
  switch arguments.length
    when 0
      0
    when 1
      return collection.deepMap(value, number)  if isCollection(value)
      return toNumber(value)  if value instanceof BigNumber
      num = new Number(value)
      num = new Number(value.valueOf())  if isNaN(num)
      throw new SyntaxError(value.toString() + " is no valid number")  if isNaN(num)
      num
    else
      throw new error.ArgumentsError("number", arguments.length, 0, 1)

module?.exports = number
