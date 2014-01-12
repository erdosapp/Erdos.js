util = require('../util/index')
Index = require('./Index')
Range = require('./Range')

number = util.Number
string = util.String
array  = util.Array
object = util.Object

isArray       = Array.isArray
validateIndex = array.validateIndex

class Matrix
  ###
  # @constructor Matrix
  # 
  # A Matrix is a wrapper around an Array. A matrix can hold a multi dimensional
  # array. A matrix can be constructed as:
  # var matrix = new Matrix(data)
  # 
  # Matrix contains the functions to resize, get and set values, get the size,
  # clone the matrix and to convert the matrix to a vector, array, or scalar.
  # Furthermore, one can iterate over the matrix using map and forEach.
  # The internal Array of the Matrix can be accessed using the function valueOf.
  # 
  # Example usage:
  # var matrix = new Matrix([[1, 2], [3, 4]);
  # matix.size();              // [2, 2]
  # matrix.resize([3, 2], 5);
  # matrix.valueOf();          // [[1, 2], [3, 4], [5, 5]]
  # matrix.subset([1,2])       // 3 (indexes are zero-based)
  # 
  # @param {Array | Matrix} [data]    A multi dimensional array
  ###
  constructor: (data) ->
    if data instanceof Matrix     
      # clone data from a Matrix
      @_data = data.clone()._data
    else if isArray(data)   
      # use array as is
      @_data = data
    else if data?
      # unsupported type
      throw new TypeError("Unsupported type of data (" + util.types(data) + ")")
    else
      # nothing provided
      @_data = []
    
    # verify the size of the array
    @_size = array.size(@_data)

  ###
  # Get a submatrix of this matrix
  # @param {Matrix} matrix
  # @param {Index} index   Zero-based index
  # @private
  ###
  @_get: (matrix, index) ->
    throw new TypeError("Invalid index") unless index instanceof Index

    isScalar = index.isScalar()
    if isScalar
      # return a scalar
      matrix.get index.min()
    else   
      # validate dimensions
      size = index.size()

      unless size.length is matrix._size.length
        throw new RangeError("Dimension mismatch " + "(" + size.length + " != " + matrix._size.length + ")")
      
      # retrieve submatrix
      submatrix = new Matrix(Matrix._getSubmatrix(matrix._data, index, size.length, 0))

      # TODO: more efficient when creating an empty matrix and setting _data and _size manually
      
      # squeeze matrix output
      while isArray(submatrix._data) and submatrix._data.length is 1
        submatrix._data = submatrix._data[0]
        submatrix._size.shift()

      submatrix

  ###
  # Recursively get a submatrix of a multi dimensional matrix.
  # Index is not checked for correct number of dimensions.
  # @param {Array} data
  # @param {Index} index
  # @param {number} dims   Total number of dimensions
  # @param {number} dim    Current dimension
  # @return {Array} submatrix
  # @private
  ###
  @_getSubmatrix: (data, index, dims, dim) ->
    last  = (dim is dims - 1)
    range = index.range(dim)

    if last
      range.map (i) =>
        validateIndex i, data.length
        data[i]
    else
      range.map (i) =>
        validateIndex i, data.length
        child = data[i]
        Matrix._getSubmatrix child, index, dims, dim + 1
    
  ###
  # Replace a submatrix in this matrix
  # Indexes are zero-based.
  # @param {Matrix} matrix
  # @param {Index} index
  # @param {Matrix | Array | *} submatrix
  # @param {*} [defaultValue]        Default value, filled in on new entries when
  # the matrix is resized. If not provided,
  # new matrix elements will be left undefined.
  # @return {Matrix} matrix
  # @private
  ###
  @_set: (matrix, index, submatrix, defaultValue) ->
    throw new TypeError("Invalid index") unless index instanceof Index
    
    # get index size and check whether the index contains a single value
    iSize    = index.size()
    isScalar = index.isScalar()
    
    # calculate the size of the submatrix, and convert it into an Array if needed
    sSize = undefined
    if submatrix instanceof Matrix
      sSize     = submatrix.size()
      submatrix = submatrix.valueOf()
    else
      sSize = array.size(submatrix)

    if isScalar
      # set a scalar
      
      # check whether submatrix is a scalar
      throw new TypeError("Scalar value expected")  unless sSize.length is 0
      matrix.set index.min(), submatrix, defaultValue
    else   
      # set a submatrix
      
      # validate dimensions
      if iSize.length < matrix._size.length
        throw new RangeError("Dimension mismatch " + "(" + iSize.length + " < " + matrix._size.length + ")")
      
      # unsqueeze the submatrix when needed
      i  = 0
      ii = iSize.length - sSize.length

      while i < ii
        submatrix = [submatrix]
        sSize.unshift 1
        i++
      
      # check whether the size of the submatrix matches the index size
      unless object.deepEqual(iSize, sSize)  
        throw new RangeError("Dimensions mismatch " + "(" + string.format(iSize) + " != " + string.format(sSize) + ")")

      # enlarge matrix when needed
      size = index.max().map((i) ->
        i + 1
      )
      Matrix._fit matrix, size, defaultValue
      
      # insert the sub matrix
      dims = iSize.length
      dim  = 0
      Matrix._setSubmatrix matrix._data, index, submatrix, dims, dim

    matrix

  ###
  # Replace a submatrix of a multi dimensional matrix.
  # @param {Array} data
  # @param {Index} index
  # @param {Array} submatrix
  # @param {number} dims   Total number of dimensions
  # @param {number} dim
  # @private
  ###
  @_setSubmatrix: (data, index, submatrix, dims, dim) ->
    last  = (dim is dims - 1)

    range = index.range(dim)
    if last
      range.forEach (dataIndex, subIndex) ->
        validateIndex dataIndex
        data[dataIndex] = submatrix[subIndex]

    else
      range.forEach (dataIndex, subIndex) ->
        validateIndex dataIndex
        Matrix._setSubmatrix data[dataIndex], index, submatrix[subIndex], dims, dim + 1

  ###
  # Enlarge the matrix when it is smaller than given size.
  # If the matrix is larger or equal sized, nothing is done.
  # @param {Matrix} matrix           The matrix to be resized
  # @param {Number[]} size
  # @param {*} [defaultValue]        Default value, filled in on new entries.
  # If not provided, the matrix elements will
  # be left undefined.
  # @private
  ###
  @_fit: (matrix, size, defaultValue) ->
    throw new Error("Array expected") unless isArray(size)
    newSize = object.clone(matrix._size)
    changed = false
    
    # add dimensions when needed
    while newSize.length < size.length
      newSize.unshift 0
      changed = true
    
    # enlarge size when needed
    i  = 0
    ii = size.length

    while i < ii
      if size[i] > newSize[i]
        newSize[i] = size[i]
        changed = true
      i++
    
    # resize only when size is changed
    matrix.resize newSize, defaultValue if changed

  ###
  # Get a subset of the matrix, or replace a subset of the matrix.
  # 
  # Usage:
  # var subset = matrix.subset(index)               // retrieve subset
  # var value = matrix.subset(index, replacement)   // replace subset
  # 
  # @param {Index} index
  # @param {Array | Matrix | *} [replacement]
  # @param {*} [defaultValue]        Default value, filled in on new entries when
  # the matrix is resized. If not provided,
  # new matrix elements will be left undefined.
  ###
  subset: (index, replacement, defaultValue) ->
    switch arguments.length
      when 1
        Matrix._get this, index
      
      # intentional fall through
      when 2, 3
        Matrix._set this, index, replacement, defaultValue
      else
        throw new SyntaxError("Wrong number of arguments")

  ###
  # Get a single element from the matrix.
  # @param {Number[]} index   Zero-based index
  # @return {*} value
  ###
  get: (index) ->
    throw new Error("Array expected") unless isArray(index)

    unless index.length is @_size.length
      throw new RangeError("Dimension mismatch " + "(" + index.length + " != " + @_size.length + ")")
    
    data = @_data
    i    = 0
    ii   = index.length

    while i < ii
      index_i = index[i]
      validateIndex index_i, data.length
      data = data[index_i]
      i++

    object.clone data

  ###
  # Replace a single element in the matrix.
  # @param {Number[]} index   Zero-based index
  # @param {*} value
  # @param {*} [defaultValue]        Default value, filled in on new entries when
  # the matrix is resized. If not provided,
  # new matrix elements will be left undefined.
  # @return {Matrix} self
  ###
  set: (index, value, defaultValue) ->
    i  = undefined
    ii = undefined
    
    # validate input type and dimensions
    throw new Error("Array expected")  unless isArray(index)

    if index.length < @_size.length
      throw new RangeError("Dimension mismatch " + "(" + index.length + " < " + @_size.length + ")")
    
    # enlarge matrix when needed
    size = index.map((i) ->
      i + 1
    )

    Matrix._fit this, size, defaultValue
    
    # traverse over the dimensions
    data = @_data
    i    = 0
    ii   = index.length - 1

    while i < ii
      index_i = index[i]
      validateIndex index_i, data.length
      data = data[index_i]
      i++
    
    # set new value
    index_i = index[index.length - 1]
    validateIndex index_i, data.length
    data[index_i] = value

    this

  ###
  # Resize the matrix
  # @param {Number[]} size
  # @param {*} [defaultValue]        Default value, filled in on new entries.
  # If not provided, the matrix elements will
  # be left undefined.
  # @return {Matrix} self            The matrix itself is returned
  ###
  resize: (size, defaultValue) ->
    @_size = object.clone(size)
    @_data = array.resize(@_data, @_size, defaultValue)
    this

  ###
  # Create a clone of the matrix
  # @return {Matrix} clone
  ###
  clone: ->
    matrix = new Matrix()
    matrix._data = object.clone(@_data)
    matrix._size = object.clone(@_size)
    matrix

  ###
  # Retrieve the size of the matrix.
  # @returns {Number[]} size
  ###
  size: ->
    @_size

  ###
  # Create a new matrix with the results of the callback function executed on
  # each entry of the matrix.
  # @param {function} callback   The callback function is invoked with three
  # parameters: the value of the element, the index
  # of the element, and the Matrix being traversed.
  # @return {Matrix} matrix
  ###
  map: (callback) ->
    me     = this
    matrix = new Matrix()
    index  = []
    
    recurse = (value, dim) ->
      if isArray(value)
        value.map (child, i) ->
          index[dim] = i
          recurse child, dim + 1
      else
        callback value, index, me

    matrix._data = recurse(@_data, 0)
    matrix._size = object.clone(@_size)
    matrix

  ###
  # Execute a callback function on each entry of the matrix.
  # @param {function} callback   The callback function is invoked with three
  # parameters: the value of the element, the index
  # of the element, and the Matrix being traversed.
  ###
  forEach: (callback) ->
    me    = this
    index = []

    recurse = (value, dim) ->
      if isArray(value)
        value.forEach (child, i) ->
          index[dim] = i
          recurse child, dim + 1
      else
        callback value, index, me

    recurse @_data, 0

  ###
  # Create an Array with a copy of the data of the Matrix
  # @returns {Array} array
  ###
  toArray: ->
    object.clone @_data

  ###
  # Get the primitive value of the Matrix: a multidimensional array
  # @returns {Array} array
  ###
  valueOf: ->
    @_data

  ###
  # Get a string representation of the matrix, with optional formatting options.
  # @param {Object | Number | Function} [options]  Formatting options. See
  # lib/util/number:format for a
  # description of the available
  # options.
  # @returns {String} str
  ###
  format: (options) ->
    string.format @_data, options

  ###
  # Get a string representation of the matrix
  # @returns {String} str
  ###
  toString: ->
    string.format @_data

  ###
  # Test whether an object is a Matrix
  # @param {*} object
  # @return {Boolean} isMatrix
  ###
  @isMatrix: (object) ->
    object instanceof Matrix

module?.exports = Matrix
