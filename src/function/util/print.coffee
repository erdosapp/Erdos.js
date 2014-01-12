error  = require('../../type/Error')
string = require('../../util/string')

isString = string.isString

module.exports = (erdos, settings) ->
  ###
  # Interpolate values into a string template.
  # erdos.print(template, values)
  # erdos.print(template, values, precision)
  # 
  # Example usage:
  # 
  # // the following outputs: 'The value of pi is 3.141592654'
  # erdos.format('The value of pi is $pi', {pi: erdos.pi}, 10);
  # 
  # // the following outputs: 'hello Mary! The date is 2013-03-23'
  # erdos.format('Hello $user.name! The date is $date', {
  # user: {
  # name: 'Mary',
  # },
  # date: new Date().toISOString().substring(0, 10)
  # });
  # 
  # @param {String} template
  # @param {Object} values
  # @param {Number} [precision]  Number of digits to format numbers.
  # If not provided, the value will not be rounded.
  # @return {String} str
  ###
  print = (template, values, precision) ->
    num = arguments.length
    throw new error.ArgumentsError("print", num, 2, 3)  if num isnt 2 and num isnt 3
    throw new TypeError("String expected as first parameter in function format")  unless isString(template)
    throw new TypeError("Object expected as second parameter in function format")  unless values instanceof Object
    
    # format values into a string
    template.replace /\$([\w\.]+)/g, (original, key) ->
      keys = key.split(".")
      value = values[keys.shift()]
      while keys.length and value isnt undefined
        k = keys.shift()
        value = (if k then value[k] else value + ".")

      if value isnt undefined
        unless isString(value)
          return erdos.format(value, precision)
        else
          return value
          
      original

  erdos.print = print
