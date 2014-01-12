module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  Matrix = require('../../type/Matrix')

  object  = util.Object
  array   = util.Array
  isArray = Array.isArray

  ###
  # Remove singleton dimensions from a matrix
  # 
  # squeeze(x)
  # 
  # @param {Matrix | Array} x
  # @return {Matrix | Array} res
  ###
  squeeze = (x) ->
    throw new error.ArgumentsError("squeeze", arguments.length, 1)  unless arguments.length is 1
    if isArray(x)
      array.squeeze object.clone(x)
    else if x instanceof Matrix
      res = array.squeeze(x.toArray())
      (if isArray(res) then new Matrix(res) else res)
    else
      # scalar
      object.clone x

  erdos.squeeze = squeeze
