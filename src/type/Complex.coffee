util = require('../util/index')

numberutil = util.Number

isNumber = util.Number.isNumber
isString = util.String.isString

class ComplexParser
  ###
  # Parse a complex number from a string. For example Complex.parse("2 + 3i")
  # will return a Complex value where re = 2, im = 3.
  # Returns null if provided string does not contain a valid complex number.
  # @param {String} str
  # @returns {Complex | null} complex
  ###
  constructor: (str) ->
    @text  = str
    @index = -1
    @c     = ""

  skipWhitespace: ->
    @next() while @c is " " or @c is "\t"

  isDigitDot: (c) ->
    (c >= "0" and c <= "9") or c is "."

  isDigit: (c) ->
    c >= "0" and c <= "9"

  next: ->
    @index++
    @c = @text.charAt(@index)

  revert: (oldIndex) ->
    @index = oldIndex
    @c     = @text.charAt(@index)

  parseNumber: ->
    number   = ""
    oldIndex = undefined
    oldIndex = @index

    if @c is "+"
      @next()
    else if @c is "-"
      number += @c
      @next()

    unless @isDigitDot(@c)
      # a + or - must be followed by a digit
      @revert oldIndex
      return null
    
    # get number, can have a single dot
    if @c is "."
      number += @c
      @next()

      unless @isDigit(@c)
        # this is no legal number, it is just a dot
        @revert oldIndex
        return null
    else
      while @isDigit(@c)
        number += @c
        @next()
      if @c is "."
        number += @c
        @next()

    while @isDigit(@c)
      number += @c
      @next()
    
    # check for exponential notation like "2.3e-4" or "1.23e50"
    if @c is "E" or @c is "e"
      number += @c
      @next()

      if @c is "+" or @c is "-"
        number += @c
        @next()
      
      # Scientific notation MUST be followed by an exponent
      unless @isDigit(@c)
        # this is no legal number, exponent is missing.
        @revert oldIndex
        return null

      while @isDigit(@c)
        number += @c
        @next()

    number

  parseComplex: ->
    # check for 'i', '-i', '+i'
    cnext = @text.charAt(@index + 1)

    if @c is "I" or @c is "i"
      @next()
      return "1"
    else if (@c is "+" or @c is "-") and (cnext is "I" or cnext is "i")
      number = (if (@c is "+") then "1" else "-1")
      @next()
      @next()
      return number

    null

  go: ->
    return null unless isString(@text)

    @next()
    @skipWhitespace()
    first = @parseNumber()

    if first
      if @c is "I" or @c is "i"
        
        # pure imaginary number
        @next()
        @skipWhitespace()
        
        # garbage at the end. not good.
        return null if @c
        return new Complex(0, Number(first))
      else
        # complex and real part
        @skipWhitespace()
        separator = @c

        if separator isnt "+" and separator isnt "-"
          # pure real number
          @skipWhitespace()
          
          # garbage at the end. not good.
          return null if @c
          return new Complex(Number(first), 0)
        else
          # complex and real part
          @next()
          @skipWhitespace()
          second = @parseNumber()

          if second
            # 'i' missing at the end of the complex number
            return null if @c isnt "I" and @c isnt "i"
            @next()
          else
            second = @parseComplex()
            # imaginary number missing after separator
            return null unless second

          if separator is "-"
            if second[0] is "-"
              second = "+" + second.substring(1)
            else
              second = "-" + second

          @next()
          @skipWhitespace()
          
          # garbage at the end. not good.
          return null if @c
          return new Complex(Number(first), Number(second))
    else 
      # check for 'i', '-i', '+i'
      first = @parseComplex()

      if first
        @skipWhitespace()
        
        # garbage at the end. not good.
        return null if @c
        return new Complex(0, Number(first))
        
    null

class Complex
  # private variables and functions for the parser
  text: undefined
  index: undefined
  c: undefined

  ###
  # Test whether value is a Complex value
  # @param {*} value
  # @return {Boolean} isComplex
  ###
  @isComplex: (value) ->
    value instanceof Complex

  ###
  # @constructor Complex
  # 
  # A complex value can be constructed in the following ways:
  # var a = new Complex();
  # var b = new Complex(re, im);
  # var c = Complex.parse(str);
  # 
  # Example usage:
  # var a = new Complex(3, -4);      // 3 - 4i
  # a.re = 5;                        // a = 5 - 4i
  # var i = a.im;                    // -4;
  # var b = Complex.parse('2 + 6i'); // 2 + 6i
  # var c = new Complex();           // 0 + 0i
  # var d = erdos.add(a, b);          // 5 + 2i
  # 
  # @param {Number} re       The real part of the complex value
  # @param {Number} [im]     The imaginary part of the complex value
  ###
  constructor: (re, im) ->
    throw new SyntaxError("Complex constructor must be called with the new operator") unless this instanceof Complex

    switch arguments.length
      when 0
        @re = 0
        @im = 0
      when 2
        throw new TypeError("Two numbers expected in Complex constructor") if not isNumber(re) or not isNumber(im)
        @re = re
        @im = im
      else
        throw new SyntaxError("Two or zero arguments expected in Complex constructor") if arguments.length isnt 0 and arguments.length isnt 2

  ###
  # Create a copy of the complex value
  # @return {Complex} clone
  ###
  clone: ->
    new Complex(@re, @im)

  ###
  # Test whether this complex number equals an other complex value.
  # Two complex numbers are equal when both their real and imaginary parts
  # are equal.
  # @param {Complex} other
  @return {boolean} isEqual
  ###
  equals: (other) ->
    (@re is other.re) and (@im is other.im)

  ###
  # Get a string representation of the complex number,
  # with optional formatting options.
  # @param {Object | Number | Function} [options]  Formatting options. See
  # lib/util/number:format for a
  # description of the available
  # options.
  # @return {String} str
  ###
  format: (options) ->
    str   = ""
    strRe = numberutil.format(@re, options)
    strIm = numberutil.format(@im, options)

    if @im is 0
      # real value
      str = strRe
    else if @re is 0
      # purely complex value
      if @im is 1
        str = "i"
      else if @im is -1
        str = "-i"
      else
        str = strIm + "i"
    else
      # complex value
      if @im > 0
        if @im is 1
          str = strRe + " + i"
        else
          str = strRe + " + " + strIm + "i"
      else
        if @im is -1
          str = strRe + " - i"
        else
          str = strRe + " - " + strIm.substring(1) + "i"
          
    str

  ###
  # Get a string representation of the complex number.
  # @return {String} str
  ###
  toString: ->
    @format()

  @parse: (str) ->
    parser = new ComplexParser(str)
    parser.go()

module?.exports = Complex
