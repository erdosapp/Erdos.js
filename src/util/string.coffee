number    = require('./number')
BigNumber = require('bignumber.js')

StringUtils = 
  ###
  # Test whether value is a String
  # @param {*} value
  # @return {Boolean} isString
  ###
  isString: (value) ->
    (value instanceof String) or (typeof value is "string")

  ###
  # Check if a text ends with a certain string.
  # @param {String} text
  # @param {String} search
  ###
  endsWith: (text, search) ->
    start = text.length - search.length
    end   = text.length

    text.substring(start, end) is search

  ###
  # Format a value of any type into a string.
  # 
  # Usage:
  # erdos.format(value)
  # erdos.format(value, precision)
  # 
  # If value is a function, the returned string is 'function' unless the function
  # has a property `description`, in that case this properties value is returned.
  # 
  # Example usage:
  # erdos.format(2/7);                // '0.2857142857142857'
  # erdos.format(erdos.pi, 3);         // '3.14'
  # erdos.format(new Complex(2, 3));  // '2 + 3i'
  # erdos.format('hello');            // '"hello"'
  # 
  # @param {*} value             Value to be stringified
  # @param {Object | Number | Function} [options]  Formatting options. See
  # lib/util/number:format for a
  # description of the available
  # options.
  # @return {String} str
  ###
  format: (value, options) ->
    return number.format(value, options) if number.isNumber(value) or value instanceof BigNumber
    return StringUtils.formatArray(value, options)  if Array.isArray(value)
    return "\"" + value + "\""           if StringUtils.isString(value)

    return (if value.syntax then value.syntax + "" else "function") if typeof value is "function"

    if value instanceof Object
      if typeof value.format is "function"
        return value.format(options)
      else
        return value.toString()

    String value

  ###
  # Recursively format an n-dimensional matrix
  # Example output: "[[1, 2], [3, 4]]"
  # @param {Array} array
  # @param {Object | Number | Function} [options]  Formatting options. See
  # lib/util/number:format for a
  # description of the available
  # options.
  # @returns {String} str
  ###
  formatArray: (array, options) ->
    if Array.isArray(array)
      str = "["
      len = array.length
      i   = 0

      while i < len
        str += ", "  unless i is 0
        str += StringUtils.formatArray(array[i], options)
        i++
      str += "]"
      str
    else
      StringUtils.format array, options

module?.exports = StringUtils
