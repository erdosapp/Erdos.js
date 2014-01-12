error    = require('../../type/Error')
isMatrix = require('../../type/Matrix').isMatrix

###
# Create a new matrix or array with the results of the callback function executed on
# each entry of the matrix/array.
# @param {Matrix/array} x      The container to iterate on.
# @param {function} callback   The callback method is invoked with three
# parameters: the value of the element, the index
# of the element, and the Matrix being traversed.
# @return {Matrix/array} container
###
map = (x, callback) ->
  throw new error.ArgumentsError("map", arguments.length, 2)  unless arguments.length is 2
  if Array.isArray(x)
    _mapArray x, callback
  else if isMatrix(x)
    x.map callback
  else
    throw new error.UnsupportedTypeError("map", x)

_mapArray = (arrayIn, callback) ->
  index = []
  recurse = (value, dim) ->
    if Array.isArray(value)
      value.map (child, i) ->
        index[dim] = i
        recurse child, dim + 1

    else
      callback value, index, arrayIn

  recurse arrayIn, 0

module?.exports = map
