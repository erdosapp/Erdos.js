util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
Unit       = require('../../type/Unit')
collection = require('../../type/Collection')

isCollection = collection.isCollection
toNumber     = util.Number.toNumber
isString     = util.String.isString

###
# Create a unit. Depending on the passed arguments, the function
# will create and return a new erdos.Unit object.
# When a matrix is provided, all elements will be converted to units.
# 
# The method accepts the following arguments:
# unit(unit : string)
# unit(value : number, unit : string)
# 
# Example usage:
# var a = erdos.unit(5, 'cm');          // 50 mm
# var b = erdos.unit('23 kg');          // 23 kg
# var c = erdos.in(a, erdos.unit('m');   // 0.05 m
# 
# @param {* | Array | Matrix} args
# @return {Unit | Array | Matrix} value
###
unit = (args) ->
  switch arguments.length
    when 1
      
      # parse a string
      arg = arguments[0]
      
      # create a clone of the unit
      return arg.clone()  if arg instanceof Unit
      if isString(arg)
        return new Unit(null, arg)  if Unit.isPlainUnit(arg) # a pure unit
        u = Unit.parse(arg) # a unit with value, like '5cm'
        return u  if u
        throw new SyntaxError("String \"" + arg + "\" is no valid unit")
      return collection.deepMap(args, unit)  if isCollection(args)
      throw new TypeError("A string or a number and string expected in function unit")
    when 2
      
      # a number and a unit
      if arguments[0] instanceof BigNumber
        
        # convert value to number
        return new Unit(toNumber(arguments[0]), arguments[1])
      else
        return new Unit(arguments[0], arguments[1])
    else
      throw new error.ArgumentsError("unit", arguments.length, 1, 2)

module?.exports = unit
