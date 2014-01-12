Node = require('./Node')

class FunctionNode extends Node
  ###
  # @constructor FunctionNode
  # Function assignment
  # 
  # @param {String} name           Function name
  # @param {String[]} variables    Variable names
  # @param {Node} expr             The function expression
  # @param {Scope} functionScope   Scope in which to write variable values
  # @param {Scope} scope           Scope to store the resulting function assignment
  ###
  constructor: (name, variables, expr, functionScope, scope) ->
    @name      = name
    @variables = variables
    @expr      = expr
    @scope     = scope
    
    # create function
    @fn = ->
      num = (if variables then variables.length else 0)
      
      # validate correct number of arguments
      throw new SyntaxError("Wrong number of arguments in function " + name + " (" + arguments.length + " provided, " + num + " expected)") unless arguments.length is num
      
      # fill in the provided arguments in the functionScope variables
      i = 0

      while i < num
        functionScope.set variables[i], arguments[i]
        i++
      
      # evaluate the expression
      @expr.eval()
    
    # add a field describing the function syntax
    @fn.syntax = name + "(" + variables.join(", ") + ")"

  ###
  # Evaluate the function assignment
  # @return {function} fn
  ###
  eval: ->
    # put the definition in the scope
    @scope.set @name, @fn
    @fn()

  ###
  # Find all nodes matching given filter
  # @param {Object} filter  See Node.find for a description of the filter settings
  # @returns {Node[]} nodes
  ###
  find: (filter) ->
    nodes = []
    
    # check itself
    nodes.push this if @match(filter)
    
    # search in expression
    nodes = nodes.concat(@expr.find(filter)) if @expr
    nodes

  ###
  # get string representation
  # @return {String} str
  ###
  toString: ->
    @fn.description

module?.exports    = FunctionNode
