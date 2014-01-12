util  = require('../../util/index')
error = require('../../type/Error')

collection = require('../../type/Collection')

number       = util.Number
isNumber     = util.Number.isNumber
isCollection = collection.isCollection

###
# Create a string or convert any object into a string.
# Elements of Arrays and Matrices are processed element wise
# @param {* | Array | Matrix} [value]
# @return {String | Array | Matrix} str
###
string = (value) ->
  switch arguments.length
    when 0
      ""
    when 1
      return number.format(value)  if isNumber(value)
      return collection.deepMap(value, string)  if isCollection(value)
      return "null"  if value is null
      value.toString()
    else
      throw new error.ArgumentsError("string", arguments.length, 0, 1)

module?.exports = string
