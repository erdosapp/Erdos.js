Node = require('./Node')

class AssignmentNode extends Node  
  ###
  # @constructor AssignmentNode
  # Define a symbol, like "a = 3.2"
  # 
  # @param {String} name       Symbol name
  # @param {Node} expr         The expression defining the symbol
  # @param {Scope} scope       Scope to store the result
  ###
  constructor: (name, expr, scope) ->
    @symbol_name  = name
    @expr  = expr
    @scope = scope

  ###
  # Evaluate the assignment
  # @return {*} result
  ###
  eval: ->
    throw new Error("Undefined symbol " + @symbol_name) if @expr is undefined
    result = @expr.eval()
    @scope.set @symbol_name, result
    result

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
  # Get string representation
  # @return {String}
  ###
  toString: ->
    @symbole_name + " = " + @expr.toString()

module?.exports = AssignmentNode
