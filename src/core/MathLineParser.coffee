module.exports = (erdos, settings) ->
  StringScanner = require("strscan").StringScanner
  MathLexer     = require('./Lexer')
  VerEx         = require("verbal-expressions")
  MathLine      = require('./MathLine')

  unless String::trim then String::trim = -> @replace /^\s+|\s+$/g, ""
  String::strip = -> if String::trim? then @trim() else @replace /^\s+|\s+$/g, ""
  String.prototype.contains = (string) ->
    return true if @indexOf(string) != -1
    false

  class MathLineParser
    @currencySymbols: ["$", "€", "฿", "¢", "£", "¥"]
    @outPutRegex: VerEx().find("=>").endOfLine()
    @numRegex: /^[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9])?/
    @OPERATORS: ["*", "+", "/", "%"]

    constructor: (string, parser=null) ->
      parser   = erdos.parser(string) unless parser
      @eparser = parser
      @ss = new StringScanner(string)

    ###
    # Returns a formatted string for the erdos (math) parser
    # Strips out any bad stuff using regex and cleverness
    ###
    go: () ->
      return @res if @res

      res = new MathLine()

      until @ss.hasTerminated()
        maybe = @ss.scanUntil(/(\s|$)/)

        unless maybe
          @ss.terminate()
          break

        if maybe == ' '
          continue
        else
          maybe = maybe.strip()
        
        if MathLineParser.currencySymbols.indexOf(maybe[0]) != -1
          maybe = maybe.substring(1, maybe.length)

        if maybe.contains("%")
          percent = parseFloat(maybe) / 100
          
          if @ss.checkUntil(/of/)
            @ss.skipUntil(/of/)
            numOrVar = @ss.scanUntil(/[a-zA-Z\d]+/).strip()

            if @eparser.scope.has(numOrVar)
              res.push('var', numOrVar)
            else
              res.push('num', numOrVar)

            res.push('op', '*')
            res.push('num', percent)
          else # we need to change the operator
            res.push('oparen', '(')
            res.push('num', res.findPrev('num')[1])
            res.push('op', '*')
            res.push('num', percent)
            res.push('cparen', ')')

          continue

        if @ss.peek(1) is '='
          res.push 'eq', maybe
          continue
        
        if MathLineParser.OPERATORS.indexOf(maybe) != -1
          res.push 'op', maybe
        else if MathLexer.DELIMITERS[maybe]
          res.push 'uop', maybe
        else if maybe.match(MathLineParser.numRegex)
          res.push 'num', maybe
        else if MathLexer.KEYWORDS.indexOf(maybe) != -1
          res.push 'key', maybe
        else if @eparser.scope.has(maybe)
          res.push 'var', maybe
        else if erdos.Unit.isPlainUnit(maybe)
          res.push 'unit', maybe

      @res = res
      @res

    ###
    # Evals the string returned from go:
    ###
    eval: () ->
      @eparser.eval(@go().toString())
    
    ###
    # Returns true if the string is a MathLine. i.e starts with a unit or ends with an output sign
    ###
    @isMathLine: (string) ->
      return true if string.match(MathLineParser.outPutRegex)
      return true if string.match(MathLineParser.numRegex)
      return true if MathLineParser.currencySymbols.indexOf(string[0])

      ## Might be a var

      scope = erparser.scope
      return true if scope.has(string)

      return false

  exports.MathLineParser = MathLineParser
