module.exports = (erdos, settings) ->
	###
	# Wrap any value in a Selector, allowing to perform chained operations on
	# the value.
	# 
	# All methods available in the erdos.js library can be called upon the selector,
	# and then will be evaluated with the value itself as first argument.
	# The selector can be closed by executing selector.done(), which will return
	# the final value.
	# 
	# Example usage:
	# erdos.select(3)
	# .add(4)
	# .subtract(2)
	# .done();     // 5
	# erdos.select( [[1, 2], [3, 4]] )
	# .set([1, 1], 8)
	# .multiply(3)
	# .done();     // [[24, 6], [9, 12]]
	# 
	# The Selector has a number of special functions:
	# - done()     Finalize the chained operation and return the selectors value.
	# - valueOf()  The same as done()
	# - toString() Executes erdos.format() onto the selectors value, returning
	# a string representation of the value.
	# - get(...)   Get a subselection of the selectors value. Only applicable when
	# the value has a method get, for example when value is a Matrix
	# or Array.
	# - set(...)   Replace a subselection of the selectors value. Only applicable
	# when the value has a method get, for example when value is a
	# Matrix or Array.
	# 
	# @param {*} value
	# @return {erdos.chaining.Selector} selector
	###
	erdos.select = (value) ->
	  # TODO: check number of arguments
	  new erdos.chaining.Selector(value)
