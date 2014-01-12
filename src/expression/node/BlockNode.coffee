 Node = require('./Node')

class BlockNode extends Node
  ###
  # @constructor BlockNode
  # Holds a set with nodes
  # @extends {Node}
  ###
  constructor: ->
    @params  = []
    @visible = []

  ###
  # Add a parameter
  # @param {Node} param
  # @param {Boolean} [visible]   true by default
  ###
  add: (param, visible) ->
    index           = @params.length
    @params[index]  = param
    @visible[index] = (if (visible isnt undefined) then visible else true)

  ###
  # Evaluate the set
  # @return {*[]} results
  # @override
  ###
  eval: ->
    # evaluate the parameters
    results = []
    i       = 0
    iMax    = @params.length

    while i < iMax
      result = @params[i].eval()
      results.push result  if @visible[i]
      i++
    results

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
  # @override
  ###
  toString: ->
    strings = []
    i       = 0
    iMax    = @params.length

    while i < iMax
      strings.push "\n  " + @params[i].toString() if @visible[i]
      i++
    "[" + strings.join(",") + "\n]"

module?.exports = BlockNode
