error    = require('../../type/Error')
isMatrix = require('../../type/Matrix').isMatrix

###
# Execute a callback method on each entry of the matrix or the array.
# @param {Matrix/array} x      The container to iterate on.
# @param {function} callback   The callback method is invoked with three
# parameters: the value of the element, the index
# of the element, and the Matrix/array being traversed.
###
forEach = (x, callback) ->
  throw new error.ArgumentsError("forEach", arguments.length, 2) unless arguments.length is 2
  if Array.isArray(x)
    _forEachArray x, callback
  else if isMatrix(x)
    x.forEach callback
  else
    throw new error.UnsupportedTypeError("forEach", x)

_forEachArray = (array, callback) ->
  index = []
  recurse = (value, dim) ->
    if Array.isArray(value)
      value.forEach (child, i) ->
        index[dim] = i # zero-based index
        recurse child, dim + 1

    else
      callback value, index, array

  recurse array, 0

module?.exports = forEach
