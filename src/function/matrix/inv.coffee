module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')
  string     = require('../../util/string')
  fsize = require('./size')(erdos, settings)

  det      = require("./det")(erdos, settings)
  eye      = require("./eye")(erdos, settings)
  divide   = erdos.divide
  add      = erdos.add
  multiply = erdos.multiply
  unary = require("../arithmetic/unary")(erdos, settings)
  
  ###
  # Calculate the inverse of a matrix
  # 
  # inv(x)
  # 
  # TODO: more documentation on inv
  # 
  # @param {Number | Complex | Array | Matrix} x
  # @return {Number | Complex | Array | Matrix} inv
  ###
  inv = (x) ->
    throw new error.ArgumentsError("inv", arguments.length, 1) unless arguments.length is 1
    size = fsize(x).valueOf()

    switch size.length
      when 0
        # scalar
        return divide(1, x)
      when 1
        
        # vector
        if size[0] is 1
          if x instanceof Matrix
            return new Matrix([divide(1, x.valueOf()[0])])
          else
            return [divide(1, x[0])]
        else
          throw new RangeError("Matrix must be square " + "(size: " + string.format(size) + ")")
      when 2
        
        # two dimensional array
        rows = size[0]
        cols = size[1]
        if rows is cols
          if x instanceof Matrix
            return new Matrix(_inv(x.valueOf(), rows, cols))
          else
            
            # return an Array
            return _inv(x, rows, cols)
        else
          throw new RangeError("Matrix must be square " + "(size: " + string.format(size) + ")")
      else
        
        # multi dimensional array
        throw new RangeError("Matrix must be two dimensional " + "(size: " + string.format(size) + ")")

  ###
  # Calculate the inverse of a square matrix
  # @param {Array[]} matrix  A square matrix
  # @param {Number} rows     Number of rows
  # @param {Number} cols     Number of columns, must equal rows
  # @return {Array[]} inv    Inverse matrix
  # @private
  ###
  _inv = (matrix, rows, cols) ->
    r = undefined
    s = undefined
    f = undefined
    value = undefined
    temp = undefined
    if rows is 1
      
      # this is a 1 x 1 matrix
      value = matrix[0][0]
      throw new Error("Cannot calculate inverse, determinant is zero")  if value is 0
      [[divide(1, value)]]
    else if rows is 2
      
      # this is a 2 x 2 matrix
      d = det(matrix)
      throw new Error("Cannot calculate inverse, determinant is zero")  if d is 0
      [[divide(matrix[1][1], d), divide(unary(matrix[0][1]), d)], [divide(unary(matrix[1][0]), d), divide(matrix[0][0], d)]]
    else
      
      # this is a matrix of 3 x 3 or larger
      # calculate inverse using gauss-jordan elimination
      #      http://en.wikipedia.org/wiki/Gaussian_elimination
      
      # make a copy of the matrix (only the arrays, not of the elements)
      A = matrix.concat()
      r = 0
      while r < rows
        A[r] = A[r].concat()
        r++
      
      # create an identity matrix which in the end will contain the
      # matrix inverse
      B = eye(rows).valueOf()
      
      # loop over all columns, and perform row reductions
      c = 0

      while c < cols
        
        # element Acc should be non zero. if not, swap content
        # with one of the lower rows
        r = c
        r++  while r < rows and A[r][c] is 0
        throw new Error("Cannot calculate inverse, determinant is zero")  if r is rows or A[r][c] is 0
        unless r is c
          temp = A[c]
          A[c] = A[r]
          A[r] = temp
          temp = B[c]
          B[c] = B[r]
          B[r] = temp
        
        # eliminate non-zero values on the other rows at column c
        Ac = A[c]
        Bc = B[c]
        r = 0
        while r < rows
          Ar = A[r]
          Br = B[r]
          unless r is c
            
            # eliminate value at column c and row r
            unless Ar[c] is 0
              f = divide(unary(Ar[c]), Ac[c])
              
              # add (f * row c) to row r to eliminate the value
              # at column c
              s = c
              while s < cols
                Ar[s] = add(Ar[s], multiply(f, Ac[s]))
                s++
              s = 0
              while s < cols
                Br[s] = add(Br[s], multiply(f, Bc[s]))
                s++
          else
            
            # normalize value at Acc to 1,
            # divide each value on row r with the value at Acc
            f = Ac[c]
            s = c
            while s < cols
              Ar[s] = divide(Ar[s], f)
              s++
            s = 0
            while s < cols
              Br[s] = divide(Br[s], f)
              s++
          r++
        c++
      B

  erdos.inv = inv
