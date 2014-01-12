number  = require('./number')
string  = require('./string')
object  = require('./object')
types   = require('./types')
isArray = Array.isArray

ArrayUtils =
  ###
  # Calculate the size of a multi dimensional array.
  # @param {Array} x
  # @Return {Number[]} size
  # @private
  ###
  _size: (x) ->
    size = []
    while isArray(x)
      size.push x.length
      x = x[0]
    size

  ###
  # Calculate the size of a multi dimensional array.
  # All elements in the array are checked for matching dimensions using the
  # method validate
  # @param {Array} x
  # @Return {Number[]} size
  # @throws RangeError
  ###
  size: (x) ->   
    # calculate the size
    s = ArrayUtils._size(x)
    
    # verify the size
    ArrayUtils.validate x, s
    
    # TODO: don't validate here? only in a Matrix constructor?
    return s

  ###
  # Recursively validate whether each element in a multi dimensional array
  # has a size corresponding to the provided size array.
  # @param {Array} array    Array to be validated
  # @param {Number[]} size  Array with the size of each dimension
  # @param {Number} dim   Current dimension
  # @throws RangeError
  # @private
  ###
  _validate: (array, size, dim) ->
    i   = undefined
    len = array.length

    throw new RangeError("Dimension mismatch (" + len + " != " + size[dim] + ")") unless len is size[dim]

    if dim < size.length - 1
      # recursively validate each child array
      dimNext = dim + 1
      i       = 0

      while i < len
        child = array[i]
        throw new RangeError("Dimension mismatch " + "(" + (size.length - 1) + " < " + size.length + ")") unless isArray(child)
        ArrayUtils._validate array[i], size, dimNext
        i++
    else
      
      # last dimension. none of the childs may be an array
      i = 0
      while i < len
        throw new RangeError("Dimension mismatch " + "(" + (size.length + 1) + " > " + size.length + ")") if isArray(array[i])
        i++

  ###
  # Validate whether each element in a multi dimensional array has
  # a size corresponding to the provided size array.
  # @param {Array} array    Array to be validated
  # @param {Number[]} size  Array with the size of each dimension
  # @throws RangeError
  ###
  validate: (array, size) ->
    isScalar = (size.length is 0)

    if isScalar
      # scalar
      throw new RangeError("Dimension mismatch (" + array.length + " != 0)") if isArray(array)
    else
      
      # array
      ArrayUtils._validate array, size, 0

  ###
  # Test whether index is an integer number with index >= 0 and index < length
  # @param {*} index         Zero-based index
  # @param {Number} [length] Length of the array
  ###
  validateIndex: (index, length) ->
    throw new TypeError("Index must be an integer (value: " + index + ")")  if not number.isNumber(index) or not number.isInteger(index)
    throw new RangeError("Index out of range (" + index + " < 0)")  if index < 0
    throw new RangeError("Index out of range (" + index + " > " + (length - 1) + ")")  if length isnt undefined and index >= length

  ###
  # Resize a multi dimensional array. The resized array is returned.
  # @param {Array} array         Array to be resized
  # @param {Array.<Number>} size Array with the size of each dimension
  # @param {*} [defaultValue]    Value to be filled in in new entries,
  # undefined by default
  # @return {Array} array         The resized array
  ###
  resize: (array, size, defaultValue) ->
    # TODO: add support for scalars, having size=[] ?
    
    # check the type of the arguments
    throw new TypeError("Array expected")                  if not isArray(array) or not isArray(size)
    throw new Error("Resizing to scalar is not supported") if size.length is 0
    
    # check whether size contains positive integers
    size.forEach (value) ->
      if not number.isNumber(value) or not number.isInteger(value) or value < 0
        throw new TypeError("Invalid size, must contain positive integers " + "(size: " + string.format(size) + ")")

    # count the current number of dimensions
    dims = 1
    elem = array[0]

    while isArray(elem)
      dims++
      elem = elem[0]
    
    # adjust the number of dimensions when needed
    while dims < size.length # add dimensions
      array = [array]
      dims++

    while dims > size.length # remove dimensions
      array = array[0]
      dims--
    
    # recursively resize the array
    ArrayUtils._resize array, size, 0, defaultValue
    array

  ###
  # Recursively resize a multi dimensional array
  # @param {Array} array         Array to be resized
  # @param {Number[]} size       Array with the size of each dimension
  # @param {Number} dim          Current dimension
  # @param {*} [defaultValue]    Value to be filled in in new entries,
  # undefined by default.
  # @private
  ###
  _resize: (array, size, dim, defaultValue) ->
    throw new Error("Array expected") unless isArray(array)
    i      = undefined
    elem   = undefined
    oldLen = array.length
    newLen = size[dim]
    minLen = Math.min(oldLen, newLen)
    
    # apply new length
    array.length = newLen
    if dim < size.length - 1     
      # non-last dimension
      dimNext = dim + 1
      
      # resize existing child arrays
      i = 0
      while i < minLen  
        # resize child array
        elem = array[i]
        ArrayUtils._resize elem, size, dimNext, defaultValue
        i++
      
      # create new child arrays
      i = minLen
      while i < newLen
        # get child array
        elem = []
        array[i] = elem
        
        # resize new child array
        ArrayUtils._resize elem, size, dimNext, defaultValue
        i++
    else      
      # last dimension
      if defaultValue isnt undefined    
        # fill new elements with the default value
        i = oldLen
        while i < newLen
          array[i] = object.clone(defaultValue)
          i++
          
  ###
  # Squeeze a multi dimensional array
  # @param {Array} array
  # @return {Array} array
  # @private
  ###
  squeeze: (array) ->
    array = array[0] while isArray(array) and array.length is 1
    array

  ###
  # Unsqueeze a multi dimensional array: add dimensions when missing
  # @param {Array} array
  # @param {Number} dims   Number of desired dimensions
  # @return {Array} array
  # @private
  ###
  unsqueeze: (array, dims) ->
    size = ArrayUtils.size(array)
    i    = 0
    ii   = (dims - size.length)

    while i < ii
      array = [array]
      i++
    array

module?.exports = ArrayUtils
