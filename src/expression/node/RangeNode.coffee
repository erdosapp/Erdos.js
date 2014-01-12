number = require('../../util/number')
Node   = require('./Node')

BigNumber = require('bignumber.js')
Range     = require('../../type/Range')
Matrix    = require('../../type/Matrix')

toNumber = number.toNumber

class RangeNode extends Node
  ###
  # @constructor RangeNode
  # create a range
  # @param {Object} erdos             The erdos namespace containing all functions
  # @param {Object} settings         Settings of the erdos
  @param {Node[]} params
  ###
  constructor: (erdos, settings, params) ->
    @erdos    = erdos
    @settings = settings
    @start    = null # included lower-bound
    @end      = null # included upper-bound
    @step     = null # optional step

    if params.length is 2
      @start = params[0]
      @end   = params[1]
    else if params.length is 3
      @start  = params[0]
      @step   = params[1]
      @end    = params[2]
    else
      # TODO: better error message
      throw new SyntaxError("Wrong number of arguments")

  ###
  # Evaluate the range
  # @return {*} result
  ###
  eval: ->
    # evaluate the parameters
    range = @_evalParams()
    start = range.start
    step  = range.step
    end   = range.end
    
    # generate the range (upper-bound included!)
    array = []
    x     = start
    if step > 0
      while x <= end
        array.push x
        x += step
    else if step < 0
      while x >= end
        array.push x
        x += step

    (if (@settings.matrix is "array") then array else new Matrix(array))

  ###
  # Create a Range from a RangeNode
  # @return {Range} range
  ###
  toRange: ->
    # evaluate the parameters
    range = @_evalParams()
    start = range.start
    step  = range.step
    end   = range.end
    
    # upper-bound be included, so compensate for that
    # NOTE: this only works for integer values!
    end = @erdos.add(end, (if (step > 0) then 1 else -1))
    
    # create the range
    new Range(start, end, step)

  ###
  # Evaluate the range parameters start, step, end
  # @returns {{start: Number, end: Number, step: Number}} range
  # @private
  ###
  _evalParams: ->
    start = @start.eval()
    end   = @end.eval()
    step  = (if @step then @step.eval() else 1)
    
    # TODO: implement support for big numbers
    
    # convert big numbers to numbers
    start = toNumber(start) if start instanceof BigNumber
    end   = toNumber(end)   if end instanceof   BigNumber
    step  = toNumber(step)  if step instanceof  BigNumber
    
    # validate parameters
    throw new TypeError("Parameter start must be a number") unless number.isNumber(start)
    throw new TypeError("Parameter end must be a number")   unless number.isNumber(end)
    throw new TypeError("Parameter step must be a number")  unless number.isNumber(step)

    start: start
    end: end
    step: step

  ###
  # Find all nodes matching given filter
  # @param {Object} filter  See Node.find for a description of the filter settings
  # @returns {Node[]} nodes
  ###
  find: (filter) ->
    nodes = []
    
    # check itself
    nodes.push this if @match(filter)
    
    # search in parameters
    nodes = nodes.concat(@start.find(filter)) if @start
    nodes = nodes.concat(@step.find(filter))  if @step
    nodes = nodes.concat(@end.find(filter))   if @end
    nodes

  ###
  # Get string representation
  # @return {String} str
  ###
  toString = ->
    
    # format the range like "start:step:end"
    str = @start.toString()
    str += ":" + @step.toString()  if @step
    str += ":" + @end.toString()
    str

module?.exports = RangeNode
