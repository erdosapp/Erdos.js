Node   = require('./Node')
string = require('../../util/string')

class ConstantNode extends Node
	###
	# @constructor ConstantNode
	# @param {*} value
	# @extends {Node}
	###
	constructor: (value) ->
	  @value = value

	###
	# Evaluate the constant (just return it)
	# @return {*} value
	###
	eval: ->
	  @value

	###
	# Get string representation
	# @return {String} str
	###
	toString: ->
	  string.format @value

module?.exports    = ConstantNode
