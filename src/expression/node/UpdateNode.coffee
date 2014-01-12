number = require('../../util/number')

Node       = require('./Node')
RangeNode  = require('./RangeNode')
SymbolNode = require('./SymbolNode')

BigNumber = require('bignumber.js')
Index     = require('../../type/Index')
Range     = require('../../type/Range')

isNumber = number.isNumber
toNumber = number.toNumber

class UpdateNode extends Node
  ###
  # @constructor UpdateNode
  # Update a symbol value, like a(2,3) = 4.5
  # 
  # @param {Object} erdos                 The erdos namespace containing all functions
  # @param {String} name                 Symbol name
  # @param {Node[] | undefined} params   One or more parameters
  # @param {Scope[]}  paramScopes        A scope for every parameter, where the
  # index variable 'end' can be defined.
  # @param {Node} expr                   The expression defining the symbol
  # @param {Scope} scope                 Scope to store the result
  ###
  constructor: (erdos, name, params, paramScopes, expr, scope) ->
    @erdos       = erdos
    @name        = name
    @params      = params
    @paramScopes = paramScopes
    @expr        = expr
    @scope       = scope
    
    # check whether any of the params expressions uses the context symbol 'end'
    @hasContextParams = false
    filter =
      type: SymbolNode
      properties:
        name: "end"

    i = 0
    len = params.length

    while i < len
      if params[i].find(filter).length > 0
        @hasContextParams = true
        break
      i++

  ###
  # Evaluate the assignment
  # @return {*} result
  ###
  eval: ->
    throw new Error("Undefined symbol " + @name)  if @expr is undefined
    result = undefined
    
    # test if definition is currently undefined
    prevResult = @scope.get(@name)
    throw new Error("Undefined symbol " + @name)  if prevResult is undefined
    
    # evaluate the values of context parameter 'end' when needed
    if @hasContextParams and typeof prevResult isnt "function"
      paramScopes = @paramScopes
      size = @erdos.size(prevResult).valueOf()

      if paramScopes and size
        i   = 0
        len = @params.length

        while i < len
          paramScope = paramScopes[i]
          paramScope.set "end", size[i] if paramScope
          i++
    
    # change part of a matrix, for example "a=[]", "a(2,3)=4.5"
    paramResults = []
    @params.forEach (param) ->
      result = undefined

      if param instanceof RangeNode
        result = param.toRange()
      else
        result = param.eval()
      
      # convert big number to number
      result = toNumber(result) if result instanceof BigNumber
      
      # TODO: implement support for BigNumber
      
      # change from one-based to zero-based range
      if result instanceof Range
        result.start--
        result.end--
      else if isNumber(result)        
        # number
        result--
      else
        throw new TypeError("Number or Range expected")

      paramResults.push result

    
    # evaluate the expression
    exprResult = @expr.eval()
    
    # replace subset
    index  = Index.create(paramResults)
    result = @erdos.subset(prevResult, index, exprResult)
    @scope.set @name, result
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
    
    # search in parameters
    params = @params
    if params
      i = 0
      len = params.length

      while i < len
        nodes = nodes.concat(params[i].find(filter))
        i++
    
    # search in expression
    nodes = nodes.concat(@expr.find(filter)) if @expr
    nodes

  ###
  # Get string representation
  # @return {String}
  ###
  toString: ->
    str = ""
    str += @name
    str += "(" + @params.join(", ") + ")" if @params and @params.length
    str += " = "
    str += @expr.toString()
    str

module?.exports  = UpdateNode
