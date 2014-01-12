BooleanUtils =
	###
	# Test whether value is a Boolean
	# @param {*} value
	# @return {Boolean} isBoolean
	###
	isBoolean: (value) ->
	  (value instanceof Boolean) or (typeof value is "boolean")

module?.exports = BooleanUtils
