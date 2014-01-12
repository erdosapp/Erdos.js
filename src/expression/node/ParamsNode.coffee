number = require('../../util/number')

Node       = require('./Node')
RangeNode  = require('./RangeNode')
SymbolNode = require('./SymbolNode')

BigNumber = require('bignumber.js')
Index     = require('../../type/Index')
Range     = require('../../type/Range')

isNumber = number.isNumber
toNumber = number.toNumber

class ParamsNode extends Node 
  ###
  # @constructor ParamsNode
  # invoke a list with parameters on the results of a node
  # @param {Object} erdos The erdos namespace containing all functions
  # @param {Node} object
  # @param {Node[]} params
  # @param {Scope[]} paramScopes     A scope for every parameter, where the
  index variable 'end' can be defined.
  ###
  constructor: (erdos, object, params, paramScopes) ->
    @erdos       = erdos
    @object      = object
    @params      = params
    @paramScopes = paramScopes
    
    # check whether any of the params expressions uses the context symbol 'end'
    @hasContextParams = false
    if params
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
  # Evaluate the parameters
  # @return {*} result
  ###
  eval: ->
    i       = undefined
    len     = undefined
    params  = undefined
    results = undefined
    
    # evaluate the object
    object = @object
    throw new Error("Node undefined") if object is undefined

    obj = object.eval()
    
    # evaluate the values of context parameter 'end' when needed
    if @hasContextParams and typeof obj isnt "function"
      paramScopes = @paramScopes
      size        = @erdos.size(obj).valueOf()

      if paramScopes and size
        i = 0
        len = @params.length

        while i < len
          paramScope = paramScopes[i]
          paramScope.set "end", size[i]  if paramScope
          i++

    if typeof obj is "function"
      # evaluate the parameters
      params  = @params
      results = []
      i       = 0
      len     = @params.length

      while i < len
        results[i] = params[i].eval()
        i++
      
      # invoke a function with the parameters
      obj.apply this, results
    else
      # evaluate the parameters as index
      params  = @params
      results = []
      i       = 0
      len     = @params.length

      while i < len
        param  = params[i]
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
        results[i] = result
        i++
      
      # get a subset of the object
      index = Index.create(results)
      @erdos.subset obj, index

  ###
  # Find all nodes matching given filter
  # @param {Object} filter  See Node.find for a description of the filter settings
  # @returns {Node[]} nodes
  ###
  find: (filter) ->
    nodes = []
    
    # check itself
    nodes.push this if @match(filter)
    
    # search object
    nodes = nodes.concat(@object.find(filter)) if @object
    
    # search in parameters
    params = @params
    if params
      i = 0
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
    # format the parameters like "(2, 4.2)"
    str = (if @object then @object.toString() else "")
    str += "(" + @params.join(", ") + ")"  if @params
    str

module?.exports  = ParamsNode
