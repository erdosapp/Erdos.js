util  = require('../util/index')
UNITS = require('./Units')

string   = util.String
isNumber = util.Number.isNumber
isString = util.String.isString

class UnitParser
  constructor: (str) ->
    @text  = str
    @index = -1
    @c     = ""

  go: ->
    return null unless isString(@text)
    @next()
    @skipWhitespace()

    value = @parseNumber()
    unit  = undefined

    if value
      unit = @parseUnit()
      @next()
      @skipWhitespace()
      
      # garbage at the end. not good.
      return null if @c
      return new Unit(new Number(value), unit) if value and unit
    else
      unit = @parseUnit()
      @next()
      @skipWhitespace()
      
      # garbage at the end. not good.
      return null if @c
      return new Unit(null, unit)

    null  

  skipWhitespace: ->
    @next() while @c is " " or @c is "\t"

  isDigitDot: (c) ->
    (c >= "0" and c <= "9") or c is "."

  isDigit: (c) ->
    c >= "0" and c <= "9"

  next: ->
    @index++
    @c = @text.charAt(@index)

  revert: (oldIndex) ->
    @index = oldIndex
    @c     = @text.charAt(@index)
 
  parseNumber: ->
    number   = ""
    oldIndex = undefined
    oldIndex = @index

    if @c is "+"
      @next()
    else if @c is "-"
      number += @c
      @next()

    unless @isDigitDot(@c)
      # a + or - must be followed by a digit
      @revert oldIndex
      return null
    
    # get number, can have a single dot
    if @c is "."
      number += @c
      @next()

      unless @isDigit(@c)
        # this is no legal number, it is just a dot
        @revert oldIndex
        return null
    else
      while @isDigit(@c)
        number += @c
        @next()
      if @c is "."
        number += @c
        @next()

    while @isDigit(@c)
      number += @c
      @next()
    
    # check for exponential notation like "2.3e-4" or "1.23e50"
    if @c is "E" or @c is "e"
      number += @c
      @next()

      if @c is "+" or @c is "-"
        number += @c
        @next()
      
      # Scientific notation MUST be followed by an exponent
      unless @isDigit(@c)
        
        # this is no legal number, exponent is missing.
        @revert oldIndex
        return null

      while @isDigit(@c)
        number += @c
        @next()
    number

  parseUnit: ->
    unit = ""

    @skipWhitespace()

    while @c and @c isnt " " and @c isnt "\t"
      unit += @c
      @next()

    unit or null

number = util.Number
class Unit
  text: undefined
  index: undefined
  c: undefined

  ###
  # Test whether value is of type Unit
  # @param {*} value
  # @return {Boolean} isUnit
  ###
  @isUnit: (value) ->
    value instanceof Unit

  ###
  # @constructor Unit
  # 
  # A unit can be constructed in the following ways:
  # var a = new Unit(value, unit);
  # var b = new Unit(null, unit);
  # var c = Unit.parse(str);
  # 
  # Example usage:
  # var a = new Unit(5, 'cm');               // 50 mm
  # var b = Unit.parse('23 kg');             // 23 kg
  # var c = erdos.in(a, new Unit(null, 'm');  // 0.05 m
  # 
  # @param {Number} [value]  A value like 5.2
  # @param {String} [unit]   A unit like "cm" or "inch"
  ###
  constructor: (value, unit) ->
    throw new Error("Unit constructor must be called with the new operator")     unless this instanceof Unit
    throw new TypeError("First parameter in Unit constructor must be a number")  if value? and not isNumber(value)
    throw new TypeError("Second parameter in Unit constructor must be a string") if unit? and not isString(unit)
   
    if unit?
      # find the unit and prefix from the string
      res = @_findUnit(unit)

      throw new SyntaxError("String \"" + unit + "\" is no unit") unless res

      @unit   = res.unit
      @prefix = res.prefix
    else
      @unit   = UNITS.UNIT_NONE
      @prefix = UNITS.PREFIX_NONE # link to a list with supported prefixes

    if value?
      @value     = @_normalize(value)
      @fixPrefix = false # is set true by the methods Unit.in and erdos.in
    else
      @value     = null
      @fixPrefix = true

  ###
  # Parse a string into a unit. Returns null if the provided string does not
  # contain a valid unit.
  # @param {String} str        A string like "5.2 inch", "4e2 kg"
  # @return {Unit | null} unit
  ###
  @parse: (str) ->
    parser = new UnitParser(str)
    parser.go()

  ###
  # create a copy of this unit
  # @return {Unit} clone
  ###
  clone: ->
    clone = new Unit()

    for p of this
      clone[p] = this[p] if @hasOwnProperty(p)

    clone

  ###
  # Normalize a value, based on its currently set unit
  # @param {Number} value
  # @return {Number} normalized value
  # @private
  ###
  _normalize: (value) ->
    (value + @unit.offset) * @unit.value * @prefix.value

  ###
  # Unnormalize a value, based on its currently set unit
  # @param {Number} value
  # @param {Number} [prefixValue]    Optional prefix value to be used
  # @return {Number} unnormalized value
  # @private
  ###
  _unnormalize: (value, prefixValue) ->
    if prefixValue is undefined
      value / @unit.value / @prefix.value - @unit.offset
    else
      value / @unit.value / prefixValue - @unit.offset

  _findUnit: (str) ->
    Unit._findUnit(str)

  ###
  # Find a unit from a string
  # @param {String} str              A string like 'cm' or 'inch'
  # @returns {Object | null} result  When found, an object with fields unit and
  # prefix is returned. Else, null is returned.
  # @private
  ###
  @_findUnit: (str) ->
    i    = 0
    iMax = UNITS.UNITS.length

    while i < iMax
      unit = UNITS.UNITS[i]
      if string.endsWith(str, unit.name)
        prefixLen  = (str.length - unit.name.length)
        prefixName = str.substring(0, prefixLen)
        prefix     = unit.prefixes[prefixName]

        if prefix isnt undefined
          # store unit, prefix, and value
          return (
            unit: unit
            prefix: prefix
          )
      i++
    null

  ###
  # Test if the given expression is a unit.
  # The unit can have a prefix but cannot have a value.
  # @param {String} unit   A plain unit without value. Can have prefix, like "cm"
  # @return {Boolean}      true if the given string is a unit
  ###
  @isPlainUnit: (unit) ->
    Unit._findUnit(unit)?

  ###
  # Test if the given expression is a unit.
  # The unit can have a prefix but cannot have a value.
  # @param {String} unit   A plain unit without value. Can have prefix, like "cm"
  # @return {Boolean}      true if the given string is a unit
  ###
  isPlainUnit: (unit) ->
    Unit.isPlainUnit(unit)

  ###
  # check if this unit has given base unit
  # @param {BASE_UNITS | undefined} base
  ###
  hasBase: (base) ->
    return (base is undefined)  if @unit.base is undefined
    @unit.base is base

  ###
  # Check if this unit has a base equal to another base
  # @param {Unit} other
  # @return {Boolean} true if equal base
  ###
  equalBase: (other) ->
    @unit.base is other.unit.base

  ###
  # Check if this unit equals another unit
  # @param {Unit} other
  # @return {Boolean} true if both units are equal
  ###
  equals: (other) ->
    @equalBase(other) and @value is other.value

  ###
  # Create a clone of this unit with a representation
  # @param {String | Unit} plainUnit   A plain unit, without value. Can have prefix, like "cm"
  # @returns {Unit} unit having fixed, specified unit
  ###
  in: (plainUnit) ->
    other = undefined

    if isString(plainUnit)
      other = new Unit(null, plainUnit)
      throw new Error("Units do not match") unless @equalBase(other)
      other.value = @value
      other
    else if plainUnit instanceof Unit
      throw new Error("Units do not match")                                  unless @equalBase(plainUnit)
      throw new Error("Cannot convert to a unit with a value")               if plainUnit.value?
      throw new Error("Unit expected on the right hand side of function in") unless plainUnit.unit?

      other = plainUnit.clone()
      other.value     = @value
      other.fixPrefix = true
      other
    else
      throw new Error("String or Unit expected as parameter")

  ###
  # Return the value of the unit when represented with given plain unit
  # @param {String | Unit} plainUnit    For example 'cm' or 'inch'
  # @return {Number} value
  ###
  toNumber: (plainUnit) ->
    other  = this["in"](plainUnit)
    prefix = (if @fixPrefix then other._bestPrefix() else other.prefix)
    other._unnormalize other.value, prefix.value

  ###
  # Get a string representation of the unit.
  # @return {String}
  ###
  toString: ->
    @format()

  ###
  # Get a string representation of the Unit, with optional formatting options.
  # @param {Object | Number | Function} [options]  Formatting options. See
  # lib/util/number:format for a
  # description of the available
  # options.
  # @return {String}
  ###
  format: (options) ->
    value = undefined
    str   = undefined

    unless @fixPrefix
      bestPrefix = @_bestPrefix()
      value      = @_unnormalize(@value, bestPrefix.value)
      str        = (if (value?) then number.format(value, options) + " " else "")
      str += bestPrefix.name + @unit.name
    else
      value = @_unnormalize(@value)
      str   = (if (value?) then number.format(value, options) + " " else "")
      str  += @prefix.name + @unit.name
    str

  ###
  # Calculate the best prefix using current value.
  # @returns {Object} prefix
  # @private
  ###
  _bestPrefix: -> 
    # find the best prefix value (resulting in the value of which
    # the absolute value of the log10 is closest to zero,
    # though with a little offset of 1.2 for nicer values: you get a
    # sequence 1mm 100mm 500mm 0.6m 1m 10m 100m 500m 0.6km 1km ...
    absValue   = Math.abs(@value / @unit.value)
    bestPrefix = UNITS.PREFIX_NONE
    bestDiff   = Math.abs(Math.log(absValue / bestPrefix.value) / Math.LN10 - 1.2)
    prefixes   = @unit.prefixes

    for p of prefixes
      if prefixes.hasOwnProperty(p)
        prefix = prefixes[p]
        if prefix.scientific
          diff = Math.abs(Math.log(absValue / prefix.value) / Math.LN10 - 1.2)
          if diff < bestDiff
            bestPrefix = prefix
            bestDiff = diff
            
    bestPrefix

module?.exports = Unit
