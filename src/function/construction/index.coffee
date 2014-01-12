util  = require('../../util/index')
error = require('../../type/Error')

BigNumber = require('bignumber.js')
Index     = require('../../type/Index')

toNumber = util.Number.toNumber

###
# Create an index. An Index can store ranges having start, step, and end
# for multiple dimensions.
# Matrix.get, Matrix.set, and erdos.subset accept an Index as input.
# 
# Usage:
# var index = erdos.index(range1, range2, ...);
# 
# Where each range can be any of:
# An array [start, end]
# An array [start, end, step]
# A number
# null, this will create select the whole dimension
# 
# The parameters start, end, and step must be integer numbers.
# 
# @param {...*} ranges
###
index = (ranges) ->
  i = new Index()
  
  # downgrade BigNumber to Number
  args = Array::slice.apply(arguments).map((arg) ->
    if arg instanceof BigNumber
      toNumber arg
    else if Array.isArray(arg)
      arg.map (elem) ->
        (if (elem instanceof BigNumber) then toNumber(elem) else elem)

    else
      arg
  )
  Index.apply i, args
  i

module?.exports = index
