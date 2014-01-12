module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')
  Matrix = require('../../type/Matrix')
  Index  = require('../../type/Index')

  array    = util.Array
  isString = util.String.isString
  isArray  = Array.isArray

  ###
  # Get or set a subset of a matrix or string
  # 
  # Usage:
  # // retrieve subset:
  # var subset = erdos.subset(value, index)
  # 
  # // replace subset:
  # var value = erdos.subset(value, index, replacement [, defaultValue])
  # 
  # Where:
  # {Array | Matrix | String} value  An array, matrix, or string
  # {Index} index                    An index containing ranges for each
  # dimension
  # {*} replacement                  An array, matrix, or scalar
  # {*} [defaultValue]        Default value, filled in on new entries when
  # the matrix is resized. If not provided,
  # new matrix elements will be left undefined.
  # @param args
  # @return res
  ###
  subset = (args) ->
    switch arguments.length
      when 2 # get subset
        _getSubset arguments[0], arguments[1]
      
      # intentional fall through
      # set subset
      when 3, 4 # set subset with default value
        _setSubset arguments[0], arguments[1], arguments[2], arguments[3]
      else # wrong number of arguments
        throw new error.ArgumentsError("subset", arguments.length, 2, 4)

  ###
  # Retrieve a subset of an value such as an Array, Matrix, or String
  # @param {Array | Matrix | String} value Object from which to get a subset
  # @param {Index} index                   An index containing ranges for each
  # dimension
  # @returns {Array | Matrix | *} subset
  # @private
  ###
  _getSubset = (value, index) ->
    m = undefined
    subset = undefined
    if isArray(value)
      m = new Matrix(value)
      subset = m.subset(index)
      subset.valueOf()
    else if value instanceof Matrix
      value.subset index
    else if isString(value)
      _getSubstring value, index
    else
      throw new error.UnsupportedTypeError("subset", value)

  ###
  # Retrieve a subset of a string
  # @param {String} str            String from which to get a substring
  # @param {Index} index           An index containing ranges for each dimension
  # @returns {string} substring
  # @private
  ###
  _getSubstring = (str, index) ->
    
    # TODO: better error message
    throw new TypeError("Index expected")  unless index instanceof Index
    throw new RangeError("Dimension mismatch (" + index.size().length + " != 1)")  unless index.size().length is 1
    range = index.range(0)
    substr = ""
    strLen = str.length
    range.forEach (v) ->
      array.validateIndex v, strLen
      substr += str.charAt(v)

    substr

  ###
  # Replace a subset in an value such as an Array, Matrix, or String
  # @param {Array | Matrix | String} value Object to be replaced
  # @param {Index} index                   An index containing ranges for each
  # dimension
  # @param {Array | Matrix | *} replacement
  # @param {*} [defaultValue]        Default value, filled in on new entries when
  # the matrix is resized. If not provided,
  # new matrix elements will be left undefined.
  # @returns {*} result
  # @private
  ###
  _setSubset = (value, index, replacement, defaultValue) ->
    m = undefined
    if isArray(value)
      m = new Matrix(erdos.clone(value))
      m.subset index, replacement, defaultValue
      m.valueOf()
    else if value instanceof Matrix
      value.clone().subset index, replacement, defaultValue
    else if isString(value)
      _setSubstring value, index, replacement, defaultValue
    else
      throw new error.UnsupportedTypeError("subset", value)

  ###
  # Replace a substring in a string
  # @param {String} str            String to be replaced
  # @param {Index} index           An index containing ranges for each dimension
  # @param {String} replacement    Replacement string
  # @param {String} [defaultValue] Default value to be uses when resizing
  # the string. is ' ' by default
  # @returns {string} result
  # @private
  ###
  _setSubstring = (str, index, replacement, defaultValue) ->
    
    # TODO: better error message
    throw new TypeError("Index expected")  unless index instanceof Index
    throw new RangeError("Dimension mismatch (" + index.size().length + " != 1)")  unless index.size().length is 1
    if defaultValue isnt undefined
      throw new TypeError("Single character expected as defaultValue")  if not isString(defaultValue) or defaultValue.length isnt 1
    else
      defaultValue = " "
    range = index.range(0)
    len = range.size()[0]
    throw new RangeError("Dimension mismatch " + "(" + range.size()[0] + " != " + replacement.length + ")")  unless len is replacement.length
    
    # copy the string into an array with characters
    strLen = str.length
    chars = []
    i = 0

    while i < strLen
      chars[i] = str.charAt(i)
      i++
    range.forEach (v, i) ->
      array.validateIndex v
      chars[v] = replacement.charAt(i)

    
    # initialize undefined characters with a space
    if chars.length > strLen
      i = strLen - 1
      len = chars.length

      while i < len
        chars[i] = defaultValue  unless chars[i]
        i++
    chars.join ""

  erdos.subset = subset
