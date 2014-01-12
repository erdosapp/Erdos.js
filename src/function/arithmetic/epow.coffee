module.exports = (erdos, settings) ->
	error = require('../../type/Error')

	collection = require('../../type/Collection')

	pow = require('./pow')(erdos, settings)

	###
	# Calculates the power of x to y element wise
	# 
	# x .^ y
	# epow(x, y)
	# 
	# @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} x
	# @param  {Number | BigNumber | Boolean | Complex | Unit | Array | Matrix} y
	# @return {Number | BigNumber | Complex | Unit | Array | Matrix} res
	###
	epow = (x, y) ->
	  throw new error.ArgumentsError("epow", arguments.length, 2) unless arguments.length is 2
	  collection.deepMap2 x, y, pow

	erdos.epow = epow
