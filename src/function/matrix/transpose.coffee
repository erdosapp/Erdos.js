module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  object = util.Object
  string = util.String

  fsize = require('./size')(erdos, settings)

  ###
  # Create the transpose of a matrix
  # 
  # transpose(x)
  # 
  # @param {Array | Matrix} x
  # @return {Array | Matrix} transpose
  ###
  transpose = (x) ->
    throw new error.ArgumentsError("transpose", arguments.length, 1)  unless arguments.length is 1
    size = fsize(x).valueOf()

    switch size.length
      when 0
        
        # scalar
        return object.clone(x)
      when 1
        
        # vector
        return object.clone(x)
      when 2
        
        # two dimensional array
        rows = size[1]
        cols = size[0]
        asMatrix = (x instanceof Matrix)
        data = x.valueOf()
        transposed = []
        transposedRow = undefined
        clone = object.clone
        
        # whoops
        throw new RangeError("Cannot transpose a 2D matrix with no rows" + "(size: " + string.format(size) + ")")  if rows is 0
        r = 0

        while r < rows
          transposedRow = transposed[r] = []
          c = 0

          while c < cols
            transposedRow[c] = clone(data[c][r])
            c++
          r++
        transposed[0] = []  if cols is 0
        return (if asMatrix then new Matrix(transposed) else transposed)
      else
        
        # multi dimensional array
        throw new RangeError("Matrix must be two dimensional " + "(size: " + string.format(size) + ")")

  erdos.transpose = transpose
