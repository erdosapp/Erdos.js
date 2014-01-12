util = require('../util/index')

Range = require('./Range')

number = util.Number

isNumber      = number.isNumber
isInteger     = number.isInteger
isArray       = Array.isArray
validateIndex = util.Array.validateIndex

class Index
  ###
  # @Constructor Index
  # Create an index. An Index can store ranges having start, step, and end
  # for multiple dimensions.
  # Matrix.get, Matrix.set, and erdos.subset accept an Index as input.
  # 
  # Usage:
  # var index = new Index(range1, range2, ...);
  # 
  # Where each range can be any of:
  # An array [start, end]
  # An array [start, end, step]
  # A number
  # An instance of Range
  # 
  # The parameters start, end, and step must be integer numbers.
  # 
  # @param {...*} ranges
  ###
  constructor: (ranges) ->
    throw new SyntaxError("Index constructor must be called with the new operator") unless this instanceof Index

    @_ranges = []
    i        = 0
    ii       = arguments.length

    while i < ii
      arg = arguments[i]

      if arg instanceof Range
        @_ranges.push arg
      else
        arg = arg.valueOf()  if arg
        if isArray(arg)
          @_ranges.push @_createRange(arg)
        else if isNumber(arg)
          @_ranges.push @_createRange([arg, arg + 1]) 
        # TODO: implement support for wildcard '*'
        else
          throw new TypeError("Range expected as Array, Number, or String")
      i++

  ###
  # Parse an argument into a range and validate the range
  # @param {Array} arg  An array with [start: Number, end: Number] and
  # optional a third element step:Number
  # @return {Range} range
  # @private
  ###
  _createRange: (arg) ->
    
    # TODO: make function _createRange simpler/faster
    
    # test whether all arguments are integers
    num = arg.length
    i   = 0

    while i < num
      throw new TypeError("Index parameters must be integer numbers") if not isNumber(arg[i]) or not isInteger(arg[i])
      i++
    switch arg.length
      when 2
        new Range(arg[0], arg[1]) # start, end
      when 3
        new Range(arg[0], arg[1], arg[2]) # start, end, step
      else
        
        # TODO: improve error message
        throw new SyntaxError("Wrong number of arguments in Index (2 or 3 expected)")

  ###
  # Retrieve the size of the index, the number of elements for each dimension.
  # @returns {Number[]} size
  ###
  size: ->
    size = []
    i    = 0
    ii   = @_ranges.length

    while i < ii
      range = @_ranges[i]
      size[i] = range.size()[0]
      i++
    size

  ###
  # Get the maximum value for each of the indexes ranges.
  # @returns {Number[]} max
  ###
  max: ->
    values = []
    i      = 0
    ii     = @_ranges.length

    while i < ii
      range = @_ranges[i]
      values[i] = range.max()
      i++
    values

  ###
  # Get the minimum value for each of the indexes ranges.
  # @returns {Number[]} min
  ###
  min: ->
    values = []
    i      = 0
    ii     = @_ranges.length

    while i < ii
      range = @_ranges[i]
      values[i] = range.min()
      i++
    values

  ###
  # Loop over each of the ranges of the index
  # @param {function} callback   Called for each range with a Range as first
  # argument, the dimension as second, and the
  # index object as third.
  ###
  forEach: (callback) ->
    i  = 0
    ii = @_ranges.length

    while i < ii
      callback @_ranges[i], i, this
      i++

  ###
  # Retrieve the range for a given dimension number from the index
  # @param {Number} dim                  Number of the dimension
  # @returns {Range | undefined} range
  ###
  range: (dim) ->
    @_ranges[dim]

  ###
  # Test whether this index contains only a single value
  # @return {boolean} isScalar
  ###
  isScalar: ->
    size = @size()
    i    = 0
    ii   = size.length

    while i < ii
      return false if size[i] isnt 1
      i++
    true

  ###
  # Expand the Index into an array.
  # For example new Index([0,3], [2,7]) returns [[0,1,2], [2,3,4,5,6]]
  # @returns {Array} array
  ###
  toArray: ->
    array = []
    i     = 0
    ii    = @_ranges.length

    while i < ii
      range = @_ranges[i]
      row   = []
      x     = range.start
      end   = range.end
      step  = range.step

      if step > 0
        while x < end
          row.push x
          x += step
      else if step < 0
        while x > end
          row.push x
          x += step
      array.push row
      i++

    array

  ###
  # Get the primitive value of the Index, a two dimensional array.
  # Equivalent to Index.toArray().
  # @returns {Array} array
  ###
  valueOf: ->
    @toArray

  ###
  # Get the string representation of the index, for example '[2:6]' or '[0:2:10, 4:7]'
  # @returns {String} str
  ###
  toString: ->
    strings = []
    i       = 0
    ii      = @_ranges.length

    while i < ii
      range = @_ranges[i]
      str = number.format(range.start)
      str += ":" + number.format(range.step)  unless range.step is 1
      str += ":" + number.format(range.end)
      strings.push str
      i++
      
    "[" + strings.join(",") + "]"

  ###
  # Create a clone of the index
  # @return {Index} clone
  ###
  clone: ->
    index = new Index()
    index._ranges = util.Object.clone(@_ranges)
    index

  ###
  # Test whether an object is an Index
  # @param {*} object
  # @return {Boolean} isIndex
  ###
  @isIndex: (object) ->
    object instanceof Index

  ###
  # Create an index from an array with ranges/numbers
  # @param {Array.<Array | Number>} ranges
  # @return {Index} index
  # @private
  ###
  @create: (ranges) ->
    index = new Index()
    Index.apply index, ranges
    index

module?.exports = Index
