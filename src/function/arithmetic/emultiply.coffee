module.exports = (erdos, settings) ->
	error = require('../../type/Error')

	collection = require('../../type/Collection')

	multiply = erdos.multiply

	###
	# Multiply two values element wise.
	# 
	# x .* y
	# emultiply(x, y)
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
	# @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} y
	# @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
	###
	emultiply = (x, y) ->
	  throw new error.ArgumentsError("emultiply", arguments.length, 2) unless arguments.length is 2
	  collection.deepMap2 x, y, multiply

	erdos.emultiply = emultiply
