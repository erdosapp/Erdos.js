###
# Determine the type of a variable
# 
# typeof(x)
# 
# @param {*} x
# @return {String} type  Lower case type, for example 'number', 'string',
# 'array', 'date'.
###
type = (x) ->
  type = typeof x
  if type is "object"
    return "null"    if x is null
    return "boolean" if x instanceof Boolean
    return "number"  if x instanceof Number
    return "string"  if x instanceof String
    return "array"   if Array.isArray(x)
    return "date"    if x instanceof Date
  type

module?.exports = type
