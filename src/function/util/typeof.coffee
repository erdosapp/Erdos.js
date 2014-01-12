module.exports = (erdos, settings) ->
  error = require('../../type/Error')
  typef = require('../../util/types')

  BigNumber = require('bignumber.js')
  Complex   = require('../../type/Complex')
  Matrix    = require('../../type/Matrix')
  Unit      = require('../../type/Unit')
  Index     = require('../../type/Index')
  Range     = require('../../type/Range')
  Selector  = require("../../chaining/Selector")(erdos)

  ###
  # Determine the type of a variable
  # 
  # typeof(x)
  # 
  # @param {*} x
  # @return {String} type  Lower case type, for example 'number', 'string',
  # 'array'.
  ###
  typeoff = (x) ->
    throw new error.ArgumentsError("typeof", arguments.length, 1) unless arguments.length is 1

    return "null" if x is null
    
    # JavaScript types
    ttype = typeof(x)
    
    # erdos.js types
    if ttype is "object"
      return "complex"   if x instanceof Complex
      return "bignumber" if x instanceof BigNumber
      return "matrix"    if x instanceof Matrix
      return "unit"      if x instanceof Unit
      return "index"     if x instanceof Index
      return "range"     if x instanceof Range
      return "selector"  if x instanceof Selector
      return "number"    if x instanceof Number
      return "string"    if x instanceof String
      return "array"     if x instanceof Array
      return "boolean"   if x instanceof Boolean
      return "date"      if x instanceof Date
      return "object"
    ttype

   erdos?.typeof = typeoff
   exports.typeof = typeoff
