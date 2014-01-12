Node       = require('./Node')
object     = require('../../util/object')
string     = require('../../util/string')
collection = require('../../type/Collection')
Matrix     = require('../../type/Matrix')

class ArrayNode extends Node
  ###
  # @constructor ArrayNode
  # Holds an 1-dimensional array with nodes
  # @param {Object} settings Object with the erdos.js configuration settings
  # @param {Array} nodes    1 dimensional array with nodes
  # @extends {Node}
  ###
  constructor: (settings, nodes) ->
    @settings = settings
    @nodes    = nodes or []

  ###
  # Evaluate the array
  # @return {Matrix | Array} results
  # @override
  ###
  eval: ->
    # evaluate all nodes in the array, and merge the results into a matrix
    nodes   = @nodes
    results = []
    i       = 0
    ii      = nodes.length

    while i < ii
      node   = nodes[i]
      result = node.eval()
      results[i] = (if (result instanceof Matrix) then result.valueOf() else result)
      i++
    (if (@settings.matrix is "array") then results else new Matrix(results))

  ###
  # Find all nodes matching given filter
  # @param {Object} filter  See Node.find for a description of the filter settings
  # @returns {Node[]} nodes
  ###
  find: (filter) ->
    results = []
    
    # check itself
    results.push this if @match(filter)
    
    # search in all nodes
    nodes = @nodes
    r     = 0
    rows  = nodes.length

    while r < rows
      nodes_r = nodes[r]
      c = 0
      cols = nodes_r.length

      while c < cols
        results = results.concat(nodes_r[c].find(filter))
        c++
      r++
    results

  ###
  # Get string representation
  # @return {String} str
  # @override
  ###
  toString = ->
    string.format @nodes

module?.exports = ArrayNode
