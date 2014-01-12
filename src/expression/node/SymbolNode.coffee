Node = require('./Node')

class SymbolNode extends Node
	###
	# @constructor SymbolNode
	# A symbol node can hold and resolve a symbol
	# @param {String} name
	# @param {Scope} scope
	# @extends {Node}
	###
	constructor: (name, scope) ->
	  @name  = name
	  @scope = scope

	###
	# Evaluate the symbol. Throws an error when the symbol is undefined.
	# @return {*} result
	# @override
	###
	eval: ->
	  # return the value of the symbol
	  value = @scope.get(@name)
	  throw new Error("Undefined symbol " + @name) if value is undefined
	  value

	###
	# Get string representation
	# @return {String} str
	# @override
	###
	toString = ->
	  @name

module?.exports  = SymbolNode
