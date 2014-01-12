module.exports = (erdos, settings) ->
	error = require('../../type/Error')

	collection = require('../../type/Collection')

	divide = erdos.divide

	###
	# Divide two values element wise.
	# 
	# x ./ y
	# edivide(x, y)
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
	# @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} y
	# @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
	###
	edivide = (x, y) ->
	  throw new error.ArgumentsError("edivide", arguments.length, 2) unless arguments.length is 2
	  collection.deepMap2 x, y, divide

	erdos.edivide = edivide
