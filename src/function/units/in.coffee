util  = require('../../util/index')
error = require('../../type/Error')

module.exports = (erdos, settings) ->
  Unit       = erdos.Unit
  collection = erdos.Collection

  isString     = util.String.isString
  isUnit       = Unit.isUnit
  isCollection = collection.isCollection

  ###
  # Change the unit of a value.
  # 
  # x in unit
  # in(x, unit)
  # 
  # For matrices, the function is evaluated element wise.
  # 
  # @param {Unit | Array | Matrix} x
  # @param {Unit | Array | Matrix} unit
  # @return {Unit | Array | Matrix} res
  ###
  inn = (x, unit) ->
    throw new error.ArgumentsError("in", arguments.length, 2) unless arguments.length is 2

    if isUnit(x) and (isUnit(unit) or isString(unit))
      return x["in"](unit)
    
    # TODO: add support for string, in that case, convert to unit
    return collection.deepMap2(x, unit, inn) if isCollection(x) or isCollection(unit)
    throw new error.UnsupportedTypeError("in", x, unit)

  erdos.in = inn
