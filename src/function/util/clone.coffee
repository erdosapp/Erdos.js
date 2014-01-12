error  = require('../../type/Error')
object = require('../../util/object')

###
# Clone an object
# 
# clone(x)
# 
# @param {*} x
# @return {*} clone
###
clone = (x) ->
  throw new error.ArgumentsError("clone", arguments.length, 1) unless arguments.length is 1
  object.clone x

module?.exports = clone
