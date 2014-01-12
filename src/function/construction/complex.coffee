util  = require('../../util/index')
error = require('../../type/Error')

BigNumber  = require('bignumber.js')
Complex    = require('../../type/Complex')
collection = require('../../type/Collection')

isCollection = collection.isCollection
isNumber     = util.Number.isNumber
toNumber     = util.Number.toNumber
isString     = util.String.isString
isComplex    = Complex.isComplex

###
# Create a complex value or convert a value to a complex value.
# 
# The method accepts the following arguments:
# complex()                           creates a complex value with zero
# as real and imaginary part.
# complex(re : number, im : string)   creates a complex value with provided
# values for real and imaginary part.
# complex(re : number)                creates a complex value with provided
# real value and zero imaginary part.
# complex(complex : Complex)          clones the provided complex value.
# complex(arg : string)               parses a string into a complex value.
# complex(array : Array)              converts the elements of the array
# or matrix element wise into a
# complex value.
# 
# Example usage:
# var a = erdos.complex(3, -4);     // 3 - 4i
# a.re = 5;                        // a = 5 - 4i
# var i = a.im;                    // -4;
# var b = erdos.complex('2 + 6i');  // 2 + 6i
# var c = erdos.complex();          // 0 + 0i
# var d = erdos.add(a, b);          // 5 + 2i
# 
# @param {* | Array | Matrix} [args]
# @return {Complex | Array | Matrix} value
###
complex = (args) ->
  switch arguments.length
    when 0
      
      # no parameters. Set re and im zero
      return new Complex(0, 0)
    when 1
      
      # parse string into a complex number
      arg = arguments[0]
      return new Complex(arg, 0)  if isNumber(arg)
      
      # convert to Number
      return new Complex(toNumber(arg), 0)  if arg instanceof BigNumber
      
      # create a clone
      return arg.clone() if isComplex(arg)
      if isString(arg)
        c = Complex.parse(arg)
        if c
          return c
        else
          throw new SyntaxError("String \"" + arg + "\" is no valid complex number")
      return collection.deepMap(arg, complex)  if isCollection(arg)
      throw new TypeError("Two numbers or a single string expected in function complex")
    when 2
      
      # re and im provided
      re = arguments[0]
      im = arguments[1]
      
      # convert re to number
      re = toNumber(re) if re instanceof BigNumber
      
      # convert im to number
      im = toNumber(im) if im instanceof BigNumber
      if isNumber(re) and isNumber(im)
        return new Complex(re, im)
      else
        throw new TypeError("Two numbers or a single string expected in function complex")
    else
      throw new error.ArgumentsError("complex", arguments.length, 0, 2)

module?.exports = complex
