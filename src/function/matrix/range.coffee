module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  isString    = util.String.isString
  isNumber    = util.Number.isNumber
  toNumber    = util.Number.toNumber
  toBigNumber = util.Number.toBigNumber

  ###
  # Create an array from a range.
  # 
  # The method accepts the following arguments
  # range(str)                   Create a range from a string, where the
  # string contains the start, optional step,
  # and end, separated by a colon.
  # range(start, end)            Create a range with start and end and a
  # default step size of 1
  # range(start, end, step)      Create a range with start, step, and end.
  # 
  # Example usage:
  # erdos.range(2, 6);        // [2,3,4,5]
  # erdos.range(2, -3, -1);   // [2,1,0,-1,-2]
  # erdos.range('2:1:6');     // [2,3,4,5]
  # 
  # @param {...*} args
  # @return {Array | Matrix} range
  ###
  range = (args) ->
    start = undefined
    end   = undefined
    step  = undefined

    switch arguments.length
      when 1
        
        # parse string into a range
        if isString(args)
          r = _parse(args)
          throw new SyntaxError("String \"" + r + "\" is no valid range")  unless r
          start = r.start
          end = r.end
          step = r.step
        else
          throw new TypeError("Two or three numbers or a single string expected in function range")
      when 2
        
        # range(start, end)
        start = arguments[0]
        end = arguments[1]
        step = 1
      when 3
        # range(start, end, step)
        start = arguments[0]
        end   = arguments[1]
        step  = arguments[2]
      else
        throw new error.ArgumentsError("range", arguments.length, 2, 3)
    
    # verify type of parameters
    throw new TypeError("Parameter start must be a number") if not isNumber(start) and (start not instanceof BigNumber)
    throw new TypeError("Parameter end must be a number")   if not isNumber(end) and (end not instanceof BigNumber)
    throw new TypeError("Parameter step must be a number")  if not isNumber(step) and (step not instanceof BigNumber)
    
    # go big
    if start instanceof BigNumber or end instanceof BigNumber or step instanceof BigNumber
      
      # create a range with big numbers
      asBigNumber = true
      
      # convert start, end, step to BigNumber
      start = toBigNumber(start) unless start instanceof BigNumber
      end   = toBigNumber(end)   unless end instanceof BigNumber
      step  = toBigNumber(step)  unless step instanceof BigNumber

      if (start not instanceof BigNumber) or (end not instanceof BigNumber) or (step not instanceof BigNumber)
          
        # not all values can be converted to big number :(
        # fall back to numbers
        asBigNumber = false
        start = toNumber(start)
        end   = toNumber(end)
        step  = toNumber(step)
    
    # generate the range
    array = (if asBigNumber then _bigRange(start, end, step) else _range(start, end, step))
    
    # return as array or matrix
    (if (settings.matrix is "array") then array else new Matrix(array))

  ###
  # Create a range with numbers
  # @param {Number} start
  # @param {Number} end
  # @param {Number} step
  # @returns {Array} range
  # @private
  ###
  _range = (start, end, step) ->
    array = []
    x = start
    if step > 0
      while x < end
        array.push x
        x += step
    else if step < 0
      while x > end
        array.push x
        x += step
    array

  ###
  # Create a range with big numbers
  # @param {BigNumber} start
  # @param {BigNumber} end
  # @param {BigNumber} step
  # @returns {Array} range
  # @private
  ###
  _bigRange = (start, end, step) ->
    array = []
    x = start.clone()
    zero = new BigNumber(0)
    if step.gt(zero)
      while x.lt(end)
        array.push x
        x = x.plus(step)
    else if step.lt(zero)
      while x.gt(end)
        array.push x
        x = x.plus(step)
    array

  ###
  # Parse a string into a range,
  # The string contains the start, optional step, and end, separated by a colon.
  # If the string does not contain a valid range, null is returned.
  # For example str='0:2:11'.
  # @param {String} str
  # @return {Object | null} range Object containing properties start, end, step
  # @private
  ###
  _parse = (str) ->
    args = str.split(":")
    nums = null
    if settings.number is "bignumber"
      
      # bignumber
      try
        nums = args.map((arg) ->
          new BigNumber(arg)
        )
      catch err
        return null
    else
      
      # number
      nums = args.map((arg) ->
        parseFloat arg
      )
      invalid = nums.some((num) ->
        isNaN num
      )
      return null  if invalid
    switch nums.length
      when 2
        start: nums[0]
        end: nums[1]
        step: 1
      when 3
        start: nums[0]
        end: nums[2]
        step: nums[1]
      else
        null

  erdos.range = range
