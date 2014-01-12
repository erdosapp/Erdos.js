module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber = require('bignumber.js')
  Matrix    = require('../../type/Matrix')

  array     = util.Array
  clone     = util.Object.clone
  isString  = util.String.isString
  toNumber  = util.Number.toNumber
  isNumber  = util.Number.isNumber
  isInteger = util.Number.isInteger
  isArray   = Array.isArray

  ###
  # Resize a matrix
  # 
  # resize(x, size)
  # resize(x, size, defaultValue)
  # 
  # @param {* | Array | Matrix} x
  # @param {Array | Matrix} size             One dimensional array with numbers
  # @param {Number | String} [defaultValue]  Undefined by default, except in
  # case of a string, in that case
  # defaultValue = ' '
  # @return {* | Array | Matrix} res
  ###
  resize = (x, size, defaultValue) ->
    throw new error.ArgumentsError("resize", arguments.length, 2, 3)  if arguments.length isnt 2 and arguments.length isnt 3
    asMatrix = (if (x  instanceof Matrix) then true else (if isArray(x) then false else (settings.matrix isnt "array")))
    x = x.valueOf()  if x instanceof Matrix # get Array
    size = size.valueOf()  if size instanceof Matrix # get Array
    
    # convert bignumbers to numbers
    size = size.map(toNumber)  if size.length and size[0] instanceof BigNumber

    if isString(x)
      _resizeString x, size, defaultValue
    else
      if size.length is 0
        
        # output a scalar
        x = x[0]  while isArray(x)
        clone x
      else
        
        # output an array/matrix
        x = [x]  unless isArray(x)
        x = clone(x)
        res = array.resize(x, size, defaultValue)
        (if asMatrix then new Matrix(res) else res)

  ###
  # Resize a string
  # @param {String} str
  # @param {Number[]} size
  # @param {string} defaultChar
  # @private
  ###
  _resizeString = (str, size, defaultChar) ->

    if defaultChar isnt undefined
      throw new TypeError("Single character expected as defaultValue")  if not isString(defaultChar) or defaultChar.length isnt 1
    else
      defaultChar = " "

    throw new Error("Dimension mismatch: (" + size.length + " != 1)") if size.length isnt 1

    len = size[0]
    throw new TypeError("Size must contain numbers")  if not isNumber(len) or not isInteger(len)

    if str.length > len
      str.substring 0, len
    else if str.length < len
      res = str
      i = 0
      ii = len - str.length

      while i < ii
        res += defaultChar
        i++
      res
    else
      return str

  erdos.resize = resize
