module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  Matrix = require('../../type/Matrix')

  object = util.Object
  array  = util.Array
  string = util.String

  multiply = erdos.multiply
  subtract = require('../arithmetic/subtract')(erdos, settings)
  round    = require('../arithmetic/round')(erdos, settings)
  eye      = require('./eye')(erdos, settings)

  ###
  # @constructor det
  # Calculate the determinant of a matrix
  # 
  # det(x)
  # 
  # @param {Array | Matrix} x
  # @return {Number} determinant
  ###
  det = (x) ->
    throw new error.ArgumentsError("det", arguments.length, 1)  unless arguments.length is 1
    size = array.size(x.valueOf())
    switch size.length
      when 0
        
        # scalar
        return object.clone(x)
      when 1
        
        # vector
        if size[0] is 1
          return object.clone(x.valueOf()[0])
        else
          throw new RangeError("Matrix must be square " + "(size: " + string.format(size) + ")")
      when 2
        
        # two dimensional array
        rows = size[0]
        cols = size[1]
        if rows is cols
          return _det(x.valueOf(), rows, cols)
        else
          throw new RangeError("Matrix must be square " + "(size: " + string.format(size) + ")")
      else
        
        # multi dimensional array
        throw new RangeError("Matrix must be two dimensional " + "(size: " + string.format(size) + ")")

  ###
  # Calculate the determinant of a matrix
  # @param {Array[]} matrix  A square, two dimensional matrix
  # @param {Number} rows     Number of rows of the matrix (zero-based)
  # @param {Number} cols     Number of columns of the matrix (zero-based)
  # @returns {Number} det
  # @private
  ###
  _det = (matrix, rows, cols) ->
    if rows is 1
      
      # this is a 1 x 1 matrix
      matrix[0][0]
    else if rows is 2
      
      # this is a 2 x 2 matrix
      # the determinant of [a11,a12;a21,a22] is det = a11*a22-a21*a12
      subtract multiply(matrix[0][0], matrix[1][1]), multiply(matrix[1][0], matrix[0][1])
    else
      
      # this is an n x n matrix
      d = 1
      lead = 0
      r = 0

      while r < rows
        break  if lead >= cols
        i = r
        
        # Find the pivot element.
        while matrix[i][lead] is 0
          i++
          if i is rows
            i = r
            lead++
            if lead is cols
              
              # We found the last pivot.
              if object.deepEqual(matrix, eye(rows).valueOf())
                return round(d, 6)
              else
                return 0
        unless i is r
          
          # Swap rows i and r, which negates the determinant.
          a = 0

          while a < cols
            temp = matrix[i][a]
            matrix[i][a] = matrix[r][a]
            matrix[r][a] = temp
            a++
          d *= -1
        
        # Scale row r and the determinant simultaneously.
        div = matrix[r][lead]
        a = 0

        while a < cols
          matrix[r][a] = matrix[r][a] / div
          a++
        d *= div
        
        # Back-substitute upwards.
        j = 0

        while j < rows
          unless j is r
            
            # Taking linear combinations does not change the det.
            c = matrix[j][lead]
            a = 0

            while a < cols
              matrix[j][a] = matrix[j][a] - matrix[r][a] * c
              a++
          j++
        lead++ # Now looking for a pivot further right.
        r++
      
      # If reduction did not result in the identity, the matrix is singular.
      if object.deepEqual(matrix, eye(rows).valueOf())
        round d, 6
      else
        0

  erdos.det = det
