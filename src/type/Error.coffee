types   = require('./../util/types')
typeoff = require("../function/util/typeof")

class UnsupportedTypeError
  ###
  # Create a TypeError with message:
  # 'Function <fn> does not support a parameter of type <type>';
  # @param {String} name   Function name
  # @param {*} [value1]
  # @param {*...} [value_n]
  # @extends TypeError
  ###
  constructor: (name, value1, value_n) ->
    if arguments.length is 2
      type1 = typeoff(value1)
      @message = "Function " + name + "(" + type1 + ") not supported"
    else if arguments.length > 2
      values = Array::splice.call(arguments, 1)
      types = values.map((value) ->
        typeoff value
      )
      @message = "Function " + name + "(" + types.join(", ") + ") not supported"
    else
      @message = "Unsupported type of argument in function " + name

class ArgumentsError extends SyntaxError
  ###
  # Create a syntax error with the message:
  # 'Wrong number of arguments in function <fn> (<count> provided, <min>-<max> expected)'
  # @param {String} name   Function name
  # @param {Number} count  Actual argument count
  # @param {Number} min    Minimum required argument count
  # @param {Number} [max]  Maximum required argument count
  # @extends SyntaxError
  ###
  constructor: (name, count, min, max) ->
    @message = "Wrong number of arguments in function " + name + " (" + count + " provided, " + min + ((if (max isnt undefined) then ("-" + max) else "")) + " expected)"

module?.exports.UnsupportedTypeError = UnsupportedTypeError
module?.exports.ArgumentsError       = ArgumentsError
