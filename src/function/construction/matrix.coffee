error  = require('../../type/Error')
Matrix = require('../../type/Matrix')

###
# Create a matrix. The function creates a new erdos.Matrix object.
# 
# The method accepts the following arguments:
# matrix()       creates an empty matrix
# matrix(data)   creates a matrix with initial data.
# 
# Example usage:
# var m = matrix([[1, 2], [3, 4]);
# m.size();                        // [2, 2]
# m.resize([3, 2], 5);
# m.valueOf();                     // [[1, 2], [3, 4], [5, 5]]
# m.get([1, 0])                    // 3
# 
# @param {Array | Matrix} [data]    A multi dimensional array
# @return {Matrix} matrix
###
matrix = (data) ->
  throw new error.ArgumentsError("matrix", arguments.length, 0, 1) if arguments.length > 1
  new Matrix(data)

module?.exports = matrix
