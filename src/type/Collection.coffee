util   = require('../util/index')
Matrix = require('./Matrix')

isArray  = Array.isArray
isString = util.String.isString

Collection =
  ###
  # Convert function arguments to an array. Arguments can have the following
  # signature:
  # fn()
  # fn(n)
  # fn(m, n, p, ...)
  # fn([m, n, p, ...])
  # @param {...Number | Array | Matrix} args
  # @returns {Array} array
  ###
  argsToArray: (args) ->
    array = undefined
    if args.length is 0
      
      # fn()
      array = []
    else if args.length is 1
      
      # fn(n)
      # fn([m, n, p, ...])
      array = args[0]
      array = array.valueOf() if array instanceof Matrix
      array = [array]         unless isArray(array)
    else
      
      # fn(m, n, p, ...)
      array = Array::slice.apply(args)
    array

  ###
  # Test whether a value is a collection: an Array or Matrix
  # @param {*} x
  # @returns {boolean} isCollection
  ###
  isCollection: (x) ->
    isArray(x) or (x instanceof Matrix)

  ###
  # Execute the callback function element wise for each element in array and any
  # nested array
  # Returns an array with the results
  # @param {Array | Matrix} array
  # @param {function} callback   The callback is called with two parameters:
  # value1 and value2, which contain the current
  # element of both arrays.
  # @return {Array | Matrix} res
  ###
  deepMap: (array, callback) ->
    if array and (typeof array.map is "function")
      array.map (x) ->
        Collection.deepMap x, callback

    else
      callback array

  ###
  # Execute the callback function element wise for each entry in two given arrays,
  # and for any nested array. Objects can also be scalar objects.
  # Returns an array with the results.
  # @param {Array | Matrix | Object} array1
  # @param {Array | Matrix | Object} array2
  # @param {function} callback   The callback is called with two parameters:
  # value1 and value2, which contain the current
  # element of both arrays.
  # @return {Array | Matrix} res
  ###
  deepMap2: (array1, array2, callback) ->
    res = undefined
    len = undefined
    i   = undefined

    if isArray(array1)
      if isArray(array2)
        
        # callback(array, array)
        throw new RangeError("Dimension mismatch " + "(" + array1.length + " != " + array2.length + ")")  unless array1.length is array2.length
        res = []
        len = array1.length
        i   = 0
        while i < len
          res[i] = Collection.deepMap2(array1[i], array2[i], callback)
          i++
      else if array2 instanceof Matrix
        
        # callback(array, matrix)
        res = Collection.deepMap2(array1, array2.valueOf(), callback)
        return new Matrix(res)
      else
        
        # callback(array, object)
        res = []
        len = array1.length
        i = 0
        while i < len
          res[i] = Collection.deepMap2(array1[i], array2, callback)
          i++
    else if array1 instanceof Matrix
      if array2 instanceof Matrix
        
        # callback(matrix, matrix)
        res = Collection.deepMap2(array1.valueOf(), array2.valueOf(), callback)
        return new Matrix(res)
      else
        
        # callback(matrix, array)
        # callback(matrix, object)
        res = Collection.deepMap2(array1.valueOf(), array2, callback)
        return new Matrix(res)
    else
      if isArray(array2)
        
        # callback(object, array)
        res = []
        len = array2.length
        i = 0
        while i < len
          res[i] = Collection.deepMap2(array1, array2[i], callback)
          i++
      else if array2 instanceof Matrix
        
        # callback(object, matrix)
        res = Collection.deepMap2(array1, array2.valueOf(), callback)
        return new Matrix(res)
      else
        
        # callback(object, object)
        res = callback(array1, array2)
    res

  ###
  # Reduce a given matrix or array to a new matrix or
  # array with one less dimension, aplying the given
  # callback in the selected dimension.
  # @param {Array | Matrix} mat
  # @param {Number} dim
  # @param {function} callback
  # @return {Array | Matrix} res
  ###
  reduce: (mat, dim, callback) ->
    if mat instanceof Matrix
      new Matrix(Collection._reduce(mat.valueOf(), dim, callback))
    else
      Collection._reduce mat, dim, callback

  ###
  # Recursively reduce a matrix
  # @param {Array} mat
  # @param {Number} dim
  # @param {Function} callback
  # @returns {Array} ret
  # @private
  ###
  _reduce: (mat, dim, callback) ->
    i    = undefined
    ret  = undefined
    val  = undefined
    tran = undefined

    if dim <= 0
      unless isArray(mat[0])
        val = mat[0]
        i = 1
        while i < mat.length
          val = callback(val, mat[i])
          i++
        val
      else
        tran = Collection._switch(mat)
        ret = []
        i = 0
        while i < tran.length
          ret[i] = Collection._reduce(tran[i], dim - 1, callback)
          i++
        ret
    else
      ret = []
      i = 0
      while i < mat.length
        ret[i] = Collection._reduce(mat[i], dim - 1, callback)
        i++
      ret

  ###
  # Transpose a matrix
  # @param {Array} mat
  # @returns {Array} ret
  # @private
  ###
  _switch: (mat) ->
    I   = mat.length
    J   = mat[0].length
    i   = undefined
    j   = undefined
    ret = []
    j   = 0

    while j < J
      tmp = []
      i = 0
      while i < I
        tmp.push mat[i][j]
        i++
      ret.push tmp
      j++
    ret

  ###
  # Recursively loop over all elements in a given multi dimensional array
  # and invoke the callback on each of the elements.
  # @param {Array | Matrix} array
  # @param {function} callback     The callback method is invoked with one
  # parameter: the current element in the array
  ###
  deepForEach: (array, callback) ->
    array = array.valueOf() if array instanceof Matrix
    i = 0
    ii = array.length

    while i < ii
      value = array[i]
      if isArray(value)
        Collection.deepForEach value, callback
      else
        callback value
      i++

module?.exports = Collection
