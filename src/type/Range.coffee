util = require('../util/index')

number = util.Number
string = util.String
array  = util.Array

class Range
  ###
  # @constructor Range
  # Create a range. A range has a start, step, and end, and contains functions
  # to iterate over the range.
  # 
  # A range can be constructed as:
  # var range = new Range(start, end);
  # var range = new Range(start, end, step);
  # 
  # To get the result of the range:
  # range.forEach(function (x) {
  # console.log(x);
  # });
  # range.map(function (x) {
  # return erdos.sin(x);
  # });
  # range.toArray();
  # 
  # Example usage:
  # var c = new Range(2, 6);         // 2:1:5
  # c.toArray();                     // [2, 3, 4, 5]
  # var d = new Range(2, -3, -1);    // 2:-1:-2
  # d.toArray();                     // [2, 1, 0, -1, -2]
  # 
  # @param {Number} start  included lower bound
  # @param {Number} end    excluded upper bound
  # @param {Number} [step] step size, default value is 1
  ###
  constructor: (start, end, step) ->
    throw new SyntaxError("Range constructor must be called with the new operator") unless this instanceof Range
    throw new TypeError("Parameter start must be a number")                         if start? and not number.isNumber(start)
    throw new TypeError("Parameter end must be a number")                           if end? and not number.isNumber(end)
    throw new TypeError("Parameter step must be a number")                          if step? and not number.isNumber(step)

    @start = (if (start?) then parseFloat(start) else 0)
    @end   = (if (end?)   then parseFloat(end)   else 0)
    @step  = (if (step?)  then parseFloat(step)  else 1)

  ###
  # Parse a string into a range,
  # The string contains the start, optional step, and end, separated by a colon.
  # If the string does not contain a valid range, null is returned.
  # For example str='0:2:11'.
  # @param {String} str
  # @return {Range | null} range
  ###
  @parse: (str) ->
    return null unless string.isString(str)

    args = str.split(":")

    nums = args.map((arg) ->
      parseFloat arg
    )

    invalid = nums.some((num) ->
      isNaN num
    )

    return null if invalid

    switch nums.length
      when 2
        new Range(nums[0], nums[1])
      when 3
        new Range(nums[0], nums[2], nums[1])
      else
        null

  ###
  # Test whether an object is a Range
  # @param {*} object
  # @return {Boolean} isRange
  ###
  @isRange: (object) ->
    object instanceof Range

  ###
  # Create a clone of the range
  # @return {Range} clone
  ###
  clone: ->
    new Range(@start, @end, @step)

  ###
  # Retrieve the size of the range.
  # Returns an array containing one number, the number of elements in the range.
  # @returns {Number[]} size
  ###
  size: ->
    len = 0
    start = @start
    step = @step
    end = @end
    diff = end - start
    if number.sign(step) is number.sign(diff)
      len = Math.ceil((diff) / step)
    else len = 0  if diff is 0
    len = 0  if isNaN(len)
    [len]

  ###
  # Calculate the minimum value in the range
  # @return {Number | undefined} min
  ###
  min: ->
    size = @size()[0]

    if size > 0
      if @step > 0    
        # positive step
        @start
      else 
        # negative step
        @start + (size - 1) * @step
    else
      undefined

  ###
  # Calculate the maximum value in the range
  # @return {Number | undefined} max
  ###
  max: ->
    size = @size()[0]

    if size > 0
      if @step > 0
        # positive step
        @start + (size - 1) * @step
      else
        # negative step
        @start
    else
      undefined

  ###
  # Execute a callback function for each value in the range.
  # @param {function} callback   The callback method is invoked with three
  # parameters: the value of the element, the index
  # of the element, and the Matrix being traversed.
  ###
  forEach: (callback) ->
    x    = @start
    step = @step
    end  = @end
    i    =  0

    if step > 0
      while x < end
        callback x, i, this
        x += step
        i++
    else if step < 0
      while x > end
        callback x, i, this
        x += step
        i++

  ###
  # Execute a callback function for each value in the Range, and return the
  # results as an array
  # @param {function} callback   The callback method is invoked with three
  # parameters: the value of the element, the index
  # of the element, and the Matrix being traversed.
  # @returns {Array} array
  ###
  map: (callback) ->
    aarray = []

    @forEach (value, index, obj) ->
      res = callback(value, index, obj)
      aarray[index] = res

    aarray

  ###
  # Create an Array with a copy of the Ranges data
  # @returns {Array} array
  ###
  toArray: ->
    aarray = []

    @forEach (value, index) ->
      aarray[index] = value

    aarray

  ###
  # Get the primitive value of the Range, a one dimensional array
  # @returns {Array} array
  ###
  valueOf: ->
    # TODO: implement a caching mechanism for range.valueOf()
    @toArray()

  ###
  # Get a string representation of the range, with optional formatting options.
  # Output is formatted as 'start:step:end', for example '2:6' or '0:0.2:11'
  # @param {Object | Number | Function} [options]  Formatting options. See
  # lib/util/number:format for a
  # description of the available
  # options.
  # @returns {String} str
  ###
  format: (options) ->
    str = number.format(@start, options)
    str += ":" + number.format(@step, options) unless @step is 1
    str += ":" + number.format(@end, options)
    str

  ###
  # Get a string representation of the range.
  # @returns {String}
  ###
  toString: ->
    @format()

module?.exports = Range
