class MathLine
  nodes: []
  @SKIPSPACECHARS: ['(', ')']

  constructor: () ->
    @nodes = []

  push: (type, value) ->
    @nodes.push [type, value]

  changePrev: (type, value) ->
    @nodes[@nodes.length - 1] = [type, value]

  findPrev: (type) ->
    for i in [@nodes.length - 1..0] by -1
      node = @nodes[i]
      return node if node[0] == type

  findPrevAndChange: (type, value) ->
    node @findPrev(type)

  toString: () ->
    res = ""

    for node, i in @nodes 
      res += " " unless i == 0 or node[1] == ')' or @nodes[i - 1][1] == '('
      res += node[1] 

    return res

module.exports = MathLine
