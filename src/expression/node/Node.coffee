class Node 
  ###
  # Evaluate the node
  # @return {*} result
  ###
  eval: ->
    throw new Error("Cannot evaluate a Node interface")

  ###
  # Find any node in the node tree matching given filter. For example, to
  # find all nodes of type SymbolNode having name 'x':
  # 
  # var results = Node.find({
  # type: SymbolNode,
  # properties: {
  # name: 'x'
  # }
  # });
  # 
  # @param {Object} filter       Available parameters:
  # {Function} type
  # {Object<String, String>} properties
  # @return {Node[]} nodes       An array with nodes matching given filter criteria
  ###
  find: ->
    (if @match(filter) then [this] else [])

  ###
  # Test if this object matches given filter
  # @param {Object} filter       Available parameters:
  # {Function} type
  # {Object<String, String>} properties
  # @return {Boolean} matches    True if there is a match
  ###
  match: (filter) ->
    match = true
    if filter
      match = false if filter.type and (this instanceof filter.type)
      if match and filter.properties
        for prop of filter.properties
          if filter.properties.hasOwnProperty(prop)
            unless this[prop] is filter.properties[prop]
              match = false
              break
    match

  ###
  # Get string representation
  # @return {String}
  ###
  toString: ->
    ""

module?.exports = Node
