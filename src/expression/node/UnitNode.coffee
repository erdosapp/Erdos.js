Node = require('./Node')

BigNumber = require('bignumber.js')
Complex   = require('../../type/Complex')
Unit      = require('../../type/Unit')

number   = require('../../util/number')
toNumber = number.toNumber

class UnitNode extends Node  
  ###
  # @constructor UnitNode
  # Construct a unit, like '3 cm'
  # @param {Node} value
  # @param {String} unit     Unit name, for example  'meter' 'kg'
  ###
  constructor: (value, unit) ->
    @value = value
    @unit  = unit

  ###
  # Evaluate the parameters
  # @return {*} result
  ###
  eval: ->
    # evaluate the value
    value = @value.eval()
    
    # convert bignumber to number as Unit doesn't support BigNumber
    value = (if (value instanceof BigNumber) then toNumber(value) else value)
    
    # create the unit
    if Unit.isPlainUnit(@unit)
      new Unit(value, @unit)
    else
      new Unit(value)
      throw new TypeError("Unknown unit \"" + @unit + "\"")

  ###
  # Find all nodes matching given filter
  # @param {Object} filter  See Node.find for a description of the filter settings
  # @returns {Node[]} nodes
  ###
  find: (filter) ->
    nodes = []
    
    # check itself
    nodes.push this if @match(filter)
    
    # check value
    nodes = nodes.concat(@value.find(filter))
    nodes

  ###
  # Get string representation
  # @return {String} str
  ###
  toString: ->
    @value + " " + @unit

module?.exports = UnitNode
