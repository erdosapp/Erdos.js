Node = require('./Node')

class OperatorNode extends Node
  ###
  # @constructor OperatorNode
  # An operator with two arguments, like 2+3
  # @param {String} name     Function name, for example '+'
  # @param {function} fn     Function, for example erdos.add
  # @param {Node[]} params   Parameters
  ###
  constructor: (name, fn, params) ->
    @name   = name
    @fn     = fn
    @params = params

  ###
  # Evaluate the parameters
  # @return {*} result
  ###
  eval: ->
    @fn.apply this, @params.map((param) ->
      param.eval()
    )

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
    params = @params
    if params
      i   = 0
      len = params.length

      while i < len
        nodes = nodes.concat(params[i].find(filter))
        i++
    nodes

  ###
  # Get string representation
  # @return {String} str
  ###
  toString: ->
    params = @params

    switch params.length
      when 1
        if @name is "-"
          
          # special case: unary minus
          "-" + params[0].toString()
        else
          
          # for example '5!'
          params[0].toString() + @name
      when 2 # for example '2+3'
        lhs = params[0].toString()
        lhs = "(" + lhs + ")"  if params[0] instanceof OperatorNode
        rhs = params[1].toString()
        rhs = "(" + rhs + ")"  if params[1] instanceof OperatorNode
        lhs + " " + @name + " " + rhs
      else # this should occur. format as a function call
        @name + "(" + @params.join(", ") + ")"

module?.exports    = OperatorNode
