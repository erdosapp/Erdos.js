BigNumber = require('bignumber.js')

NumberUtils =
  ###
  # Test whether value is a Number
  # @param {*} value
  # @return {Boolean} isNumber
  ###
  isNumber: (value) ->
    (value instanceof Number) or (typeof value is "number")

  ###
  # Check if a number is integer
  # @param {Number | Boolean} value
  # @return {Boolean} isInteger
  ###
  isInteger: (value) ->
    value is Math.round(value)

  # Note: we use ==, not ===, as we can have Booleans as well

  ###
  # Calculate the sign of a number
  # @param {Number} x
  # @returns {*}
  ###
  sign: (x) ->
    if x > 0
      1
    else if x < 0
      -1
    else
      0

  ###
  # Convert a number to a formatted string representation.
  # 
  # Syntax:
  # 
  # format(value)
  # format(value, options)
  # format(value, precision)
  # format(value, fn)
  # 
  # Where:
  # 
  # {Number} value   The value to be formatted
  # {Object} options An object with formatting options. Available options:
  # {String} notation
  # Number notation. Choose from:
  # 'fixed'          Always use regular number notation.
  # For example '123.40' and '14000000'
  # 'exponential'    Always use exponential notation.
  # For example '1.234e+2' and '1.4e+7'
  # 'auto' (default) Regular number notation for numbers
  # having an absolute value between
  # `lower` and `upper` bounds, and uses
  # exponential notation elsewhere.
  # Lower bound is included, upper bound
  # is excluded.
  # For example '123.4' and '1.4e7'.
  # {Number} precision   A number between 0 and 16 to round
  # the digits of the number.
  # In case of notations 'exponential' and
  # 'auto', `precision` defines the total
  # number of significant digits returned
  # and is undefined by default.
  # In case of notation 'fixed',
  # `precision` defines the number of
  # significant digits after the decimal
  # point, and is 0 by default.
  # {Object} exponential An object containing two parameters,
  # {Number} lower and {Number} upper,
  # used by notation 'auto' to determine
  # when to return exponential notation.
  # Default values are `lower=1e-3` and
  # `upper=1e5`.
  # Only applicable for notation `auto`.
  # {Function} fn    A custom formatting function. Can be used to override the
  # built-in notations. Function `fn` is called with `value` as
  # parameter and must return a string. Is useful for example to
  # format all values inside a matrix in a particular way.
  # 
  # Examples:
  # 
  # format(6.4);                                        // '6.4'
  # format(1240000);                                    // '1.24e6'
  # format(1/3);                                        // '0.3333333333333333'
  # format(1/3, 3);                                     // '0.333'
  # format(21385, 2);                                   // '21000'
  # format(12.071, {notation: 'fixed'});                // '12'
  # format(2.3,    {notation: 'fixed', precision: 2});  // '2.30'
  # format(52.8,   {notation: 'exponential'});          // '5.28e+1'
  # 
  # @param {Number | BigNumber} value
  # @param {Object | Function | Number} [options]
  # @return {String} str The formatted value
  ###
  format: (value, options) ->
    # handle format(value, fn)
    return options(value)  if typeof options is "function"
    
    # handle special cases
    if value is Infinity
      return "Infinity"
    else if value is -Infinity
      return "-Infinity"
    else return "NaN"  if isNaN(value)
    
    # default values for options
    notation = "auto"
    precision = undefined
    if options isnt undefined
      
      # determine notation from options
      notation = options.notation  if options.notation
      
      # determine precision from options
      if options
        if @isNumber(options)
          precision = options
        else precision = options.precision  if options.precision
    
    # handle the various notations
    switch notation
      when "fixed"
        NumberUtils.toFixed value, precision
      
      # TODO: notation 'scientific' is deprecated since version 0.16.0, remove this some day
      when "scientific"
        throw new Error("Format notation \"scientific\" is deprecated. Use \"exponential\" instead.")
      when "exponential"
        NumberUtils.toExponential value, precision
      when "auto"
        
        # determine lower and upper bound for exponential notation.
        # TODO: implement support for upper and lower to be BigNumbers themselves
        lower = 1e-3
        upper = 1e5
        if options and options.exponential
          lower = options.exponential.lower  if options.exponential.lower isnt undefined
          upper = options.exponential.upper  if options.exponential.upper isnt undefined
        
        # TODO: 'options.scientific' is deprecated since version 0.16.0, remove this some day
        else
          if options and options.scientific 
            throw new Error("options.scientific is deprecated, use options.exponential instead.")
        
        # adjust BigNumber configuration
        isBigNumber = value instanceof BigNumber
        if isBigNumber

          oldScientific = BigNumber.config().EXPONENTIAL_AT
          BigNumber.config EXPONENTIAL_AT: [Math.round(Math.log(lower) / Math.LN10), Math.round(Math.log(upper) / Math.LN10)]
        
        # handle special case zero
        return "0" if NumberUtils._isZero(value)
        
        # determine whether or not to output exponential notation
        str = undefined
        if NumberUtils._isBetween(value, lower, upper)
          
          # normal number notation
          if isBigNumber
            str = new BigNumber(value.toPrecision(precision)).toString()
          else # Number
            # Note: IE7 does not allow value.toPrecision(undefined)
            valueStr = (if precision then value.toPrecision(Math.min(precision, 21)) else value.toPrecision())
            str      = parseFloat(valueStr) + ""
        else  
          # exponential notation
          str = NumberUtils.toExponential(value, precision)
        
        # restore BigNumber configuration
        BigNumber.config EXPONENTIAL_AT: oldScientific  if isBigNumber
        
        # remove trailing zeros after the decimal point
        str.replace /((\.\d*?)(0+))($|e)/, ->
          digits = arguments[2]
          e      = arguments[4]
          (if (digits isnt ".") then digits + e else e)

      else
        throw new Error("Unknown notation \"" + notation + "\". " + "Choose \"auto\", \"exponential\", or \"fixed\".")

  ###
  # Test whether a value is zero
  # @param {Number | BigNumber} value
  # @return {boolean} isZero
  # @private
  ###
  _isZero: (value) ->
    (if (value instanceof BigNumber) then value.isZero() else (value is 0))

  ###
  # Test whether a value is inside a range:
  # 
  # lower >= value < upper
  # 
  # @param {Number | BigNumber} value
  # @param {Number} lower  Included lower bound
  # @param {Number} upper  Excluded upper bound
  # @return {boolean} isBetween
  # @private
  ###
  _isBetween: (value, lower, upper) ->
    abs = undefined
    if value instanceof BigNumber
      abs = value.abs()
      abs.gte(lower) and abs.lt(upper)
    else
      abs = Math.abs(value)
      abs >= lower and abs < upper

  ###
  # Format a number in exponential notation. Like '1.23e+5', '2.3e+0', '3.500e-3'
  # @param {Number | BigNumber} value
  # @param {Number} [precision]  Number of digits in formatted output.
  # If not provided, the maximum available digits
  # is used.
  # @returns {string} str
  ###
  toExponential: (value, precision) ->
    if precision isnt undefined
      if value instanceof BigNumber
        value.toExponential precision - 1
      else # Number
        value.toExponential Math.min(precision - 1, 20)
    else
      value.toExponential()

  ###
  # Format a number with fixed notation.
  # @param {Number | BigNumber} value
  # @param {Number} [precision=0]        Optional number of decimals after the
  # decimal point. Zero by default.
  ###
  toFixed: (value, precision) ->
    if value instanceof BigNumber
      value.toFixed precision or 0
    
    # Note: the (precision || 0) is needed as the toFixed of BigNumber has an
    # undefined default precision instead of 0.
    else # Number
      value.toFixed Math.min(precision, 20)

  ###
  # Count the number of significant digits of a number.
  # 
  # For example:
  # 2.34 returns 3
  # 0.0034 returns 2
  # 120.5e+3 returns 4
  # 
  # @param {Number} value
  # @return {Number} digits   Number of significant digits
  ###
  digits: (value) ->
    # remove exponential notation
    # remove decimal point and leading zeros
    value.toExponential().replace(/e[\+\-0-9]*$/, "").replace(/^0\.0*|\./, "").length

  ###
  # Convert a Number in to a BigNumber. If the number has 15 or mor significant
  # digits, the Number cannot be converted to BigNumber and will return the
  # original number.
  # @param {Number} number
  # @return {BigNumber | Number} bignumber
  ###
  toBigNumber: (number) ->
    if NumberUtils.digits(number) > 15
      number
    else
      new BigNumber(number)

  ###
  # Convert a BigNumber into a Number. If the number is out of range, it will
  # get the value Infinity or 0.
  # @param {BigNumber} bignumber
  # @return {Number} number
  ###
  toNumber: (bignumber) ->
    parseFloat bignumber.valueOf()

module.exports = NumberUtils
