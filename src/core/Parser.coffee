erdosjs = require('../erdos')
util    = require('../util/index')
error   = require('../type/Error')
Lexer   = require('./Lexer')

toNumber = util.Number.toNumber
isString = util.String.isString
isArray  = Array.isArray

# types
BigNumber  = require('bignumber.js')
Complex    = require('../type/Complex')
Matrix     = require('../type/Matrix')
Unit       = require('../type/Unit')
collection = require('../type/Collection')

isCollection = collection.isCollection

# scope and nodes
Scope          = require('./Scope')
ArrayNode      = require('../expression/node/ArrayNode')
AssignmentNode = require('../expression/node/AssignmentNode')
BlockNode      = require('../expression/node/BlockNode')
ConstantNode   = require('../expression/node/ConstantNode')
FunctionNode   = require('../expression/node/FunctionNode')
OperatorNode   = require('../expression/node/OperatorNode')
ParamsNode     = require('../expression/node/ParamsNode')
RangeNode      = require('../expression/node/RangeNode')
SymbolNode     = require('../expression/node/SymbolNode')
UnitNode       = require('../expression/node/UnitNode')
UpdateNode     = require('../expression/node/UpdateNode')
handlers       = require('../expression/node/Handlers')

ArgumentsError = error.ArgumentsError

class Parser extends Lexer
  constructor: (expr, scope, erdos=null) ->
    unless erdos 
      erdos = erdosjs()

    @erdos = erdos
    
    # instantiate a scope
    @scope = undefined
    if scope
      if scope instanceof Scope
        @scope = scope
      else
        @scope = new Scope(scope, null, @erdos)
    else
      @scope = new Scope(null, null, @erdos)

    unless isString(expr) or isCollection(expr)
      # oops
      throw new TypeError("String or matrix expected")

    @setInput(expr)
    @settings = @erdos.settings
   
  ###
  # Runs the parser
  #
  # @return {Node} node
  ###
  go: ->
    if isString(@expression)
      return @start(@scope)
    else
      # parse an array or matrix with expressions
      collection.deepMap @expression, (elem) ->
        @setExpression(elem or "")
        return @start(@scope)

  parse: ->
    @go()
    
  eval: (exp=null) ->
    @setExpression(exp) if exp
    @go().eval()

  @parse: (exp) ->
    new Parser(exp, @scope, @erdos).go()
    
  @eval: (exp) ->
    new Parser(exp, @scope, @erdos).go().eval()

  ###
  # Start of the parse levels below, in order of precedence
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  start: (scope) ->  
    # get the first character in expression
    @first()
    @getToken()

    node = undefined
    if @token is ""
      # empty expression
      node = new ConstantNode('')
    else
      node = @parseBlock(scope)
    
    # check for garbage at the end of the expression
    # an expression ends with a empty character '' and token_type DELIMITER
    unless @token is ""
      if @token_type is Lexer.TOKENTYPE.DELIMITER
        # user entered a not existing operator like "//"
        
        # TODO: give hints for aliases, for example with "<>" give as hint " did you mean != ?"
        throw new Error("Unknown operator " + @token)
      else
        throw new SyntaxError("Unexpected part \"" + @token + "\"")

    node

  ###
  # Parse a block with expressions. Expressions can be separated by a newline
  # character '\n', or by a semicolon ';'. In case of a semicolon, no output
  # of the preceding line is returned.
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseBlock: (scope) ->
    node    = undefined
    block   = undefined
    visible = undefined

    node = @parseAns(scope) if @token isnt "\n" and @token isnt ";" and @token isnt ""
    while @token is "\n" or @token is ";"
      unless block
        
        # initialize the block
        block = new BlockNode()
        if node
          visible = (@token isnt ";")
          block.add node, visible
     
      @getToken()

      if @token isnt "\n" and @token isnt ";" and @token isnt ""
        node    = @parseAns(scope)
        visible = (@token isnt ";")
        block.add node, visible

    return block if block
    node = @parseAns(scope)  unless node
    node

  ###
  # Parse assignment of ans.
  # Ans is assigned when the expression itself is no variable or function
  # assignment
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseAns: (scope) ->
    expression = @parseFunctionAssignment(scope)
    
    # create a variable definition for ans
    name = "ans"
    new AssignmentNode(name, expression, scope)

  ###
  # Parse a function assignment like "function f(a,b) = a*b"
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseFunctionAssignment: (scope) ->
    
    # TODO: keyword 'function' must become a reserved keyword
    # TODO: replace the 'function' keyword with an assignment operator '=>'
    if @token_type is Lexer.TOKENTYPE.SYMBOL and @token is "function"      
      # get function name
      @getToken()
      throw new SyntaxError("Function name expected") unless @token_type is Lexer.TOKENTYPE.SYMBOL
      name = @token
      
      # get parenthesis open
      @getToken()
      throw new SyntaxError("Opening parenthesis ( expected") unless @token is "("
      
      # get function variables
      functionScope = scope.createSubScope()
      variables = []
      loop
        @getToken()
        if @token_type is Lexer.TOKENTYPE.SYMBOL
          # store variable name
          variables.push @token
          @getToken()
        if @token is ","
          # ok, nothing to do, read next variable
        else if @token is ")"
          # end of variable list encountered. break loop
          break
        else
          throw new SyntaxError("Comma , or closing parenthesis ) expected\"")

      @getToken()
      throw new SyntaxError("Equal sign = expected") unless @token is "="
      
      # parse the expression, with the correct function scope
      @getToken()
      expression = @parseAssignment(functionScope)
      return new FunctionNode(name, variables, expression, functionScope, scope)
    @parseAssignment scope

  ###
  # Assignment of a variable, can be a variable like "a=2.3" or a updating an
  # existing variable like "matrix(2,3:5)=[6,7,8]"
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseAssignment: (scope) ->
    name        = undefined
    params      = undefined
    paramScopes = undefined
    expr        = undefined
    node        = @parseRange(scope)

    if @token is "="
      if node instanceof SymbolNode
        # parse the expression, with the correct function scope
        @getToken()
        name   = node.name
        params = null
        expr   = @parseAssignment(scope)
        return new AssignmentNode(name, expr, scope)
      else if (node instanceof ParamsNode) and (node.object instanceof SymbolNode)
                # parse the expression, with the correct function scope
        @getToken()
        name        = node.object.name
        params      = node.params
        paramScopes = node.paramScopes
        expr        = @parseAssignment(scope)
        return new UpdateNode(@erdos, name, params, paramScopes, expr, scope)
      else
        throw new SyntaxError("Symbol expected at the left hand side " + "of assignment operator =")

    node

  ###
  # parse range, "start:end", "start:step:end", ":", "start:", ":end", etc
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseRange: (scope) ->
    node   = undefined
    params = []

    if @token is ":"
      # implicit start=1 (one-based)
      one  = (if (@settings.number is "bignumber") then new BigNumber(1) else 1)
      node = new ConstantNode(one)
    else
      # explicit start
      node = @parseBitwiseConditions(scope)

    if @token is ":"
      params.push node
      
      # parse step and end
      while @token is ":"
        @getToken()

        if @token is ")" or @token is "," or @token is ""
          # implicit end
          params.push new SymbolNode("end", scope)
        else
          # explicit end
          params.push @parseBitwiseConditions(scope)

      node = new RangeNode(@erdos, @settings, params) if params.length

    node

  ###
  # conditional operators and bitshift
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseBitwiseConditions: (scope) ->
    node = @parseComparison(scope)
    
    # TODO: implement bitwise conditions
    #     var operators = {
    #     '&' : bitwiseand,
    #     '|' : bitwiseor,
    #     // todo: bitwise xor?
    #     '<<': bitshiftleft,
    #     '>>': bitshiftright
    #     };
    #     while (token in operators) {
    #     var name = token;
    #     var fn = operators[name];
    #
    #     @getToken();
    #     var params = [node, parseComparison()];
    #     node = new OperatorNode(name, fn, params);
    #     }
    #     
    node

  ###
  # comparison operators
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseComparison: (scope) ->
    node      = undefined
    operators = undefined
    name      = undefined
    fn        = undefined
    params    = undefined

    node = @parseConditions(scope)

    operators =
      "==": @erdos.equal
      "!=": @erdos.unequal
      "<":  @erdos.smaller
      ">":  @erdos.larger
      "<=": @erdos.smallereq
      ">=": @erdos.largereq

    while @token of operators
      name  = @token
      fn    = operators[name]

      @getToken()

      params = [node, @parseConditions(scope)]
      node   = new OperatorNode(name, fn, params)

    node

  ###
  # conditions like and, or, in
  # @param {Scope} scope
  # @return {Node} node
  # @private
  # ###
  parseConditions: (scope) ->
    node      = undefined
    operators = undefined
    name      = undefined
    fn        = undefined
    params    = undefined

    node = @parseAddSubtract(scope)
    
    # TODO: precedence of And above Or?
    # TODO: implement a method for unit to number conversion
    operators = in: @erdos["in"]
    
    # TODO: implement conditions
    #       'and' : 'and',
    #       '&&' : 'and',
    #       'or': 'or',
    #       '||': 'or',
    #       'xor': 'xor'
    #       

    while @token of operators
      name  = @token
      fn    = operators[name]

      @getToken()

      params = [node, @parseAddSubtract(scope)]
      node   = new OperatorNode(name, fn, params)

    node

  ###
  # add or subtract
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseAddSubtract: (scope) ->
    node       = undefined
    operators  = undefined
    name       = undefined
    fn         = undefined
    params     = undefined

    node = @parseMultiplyDivide(scope)

    operators =
      "+": @erdos.add
      "-": @erdos.subtract

    while @token of operators
      name = @token
      fn   = operators[name]

      @getToken()

      params = [node, @parseMultiplyDivide(scope)]
      node   = new OperatorNode(name, fn, params)
    node

  ###
  # multiply, divide, modulus
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseMultiplyDivide: (scope) ->
    node      = undefined
    operators = undefined
    name      = undefined
    fn        = undefined
    params    = undefined

    node = @parseUnit(scope)

    operators =
      "*":  @erdos.multiply
      ".*": @erdos.emultiply
      "/":  @erdos.divide
      "./": @erdos.edivide
      "%":  @erdos.mod
      mod:  @erdos.mod

    while @token of operators
      name = @token
      fn   = operators[name]

      @getToken()

      params = [node, @parseUnit(scope)]
      node   = new OperatorNode(name, fn, params)

    node

  ###
  # parse units like in '2i', '2 cm'
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseUnit: (scope) ->
    node   = undefined
    symbol = undefined

    node = @parseUnary(scope)

    while @token_type is Lexer.TOKENTYPE.SYMBOL
      symbol = @token

      @getToken()

      node = new UnitNode(node, symbol)

    node

  ###
  # Unary minus
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseUnary: (scope) ->
    name   = undefined
    fn     = undefined
    params = undefined

    if @token is "-"
      name = @token
      fn   = @erdos.unary

      @getToken()
      params = [@parseUnary(scope)]

      return new OperatorNode(name, fn, params)

    @parsePow scope

  ###
  # power
  # Note: power operator is right associative
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parsePow: (scope) ->
    node     = undefined
    leftNode = undefined
    nodes    = undefined
    ops      = undefined
    name     = undefined
    fn       = undefined
    params   = undefined

    nodes = [@parseLeftHandOperators(scope)]
    ops   = []
    
    # stack all operands of a chained power operator (like '2^3^3')
    while @token is "^" or @token is ".^"
      ops.push @token
      @getToken()
      nodes.push @parseLeftHandOperators(scope)
    
    # evaluate the operands from right to left (right associative)
    node = nodes.pop()
    while nodes.length
      leftNode = nodes.pop()
      name     = ops.pop()
      fn       = (if (name is "^") then @erdos.pow else @erdos.epow)
      params   = [leftNode, node]

      node = new OperatorNode(name, fn, params)

    node

  ###
  # Left hand operators: factorial x!, transpose x'
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseLeftHandOperators: (scope) ->
    node      = undefined
    operators = undefined
    name      = undefined
    fn        = undefined
    params    = undefined

    node = @parseNodeHandler(scope)
    operators =
      "!": @erdos.factorial
      "'": @erdos.transpose

    while @token of operators
      name = @token
      fn   = operators[name]

      @getToken()

      params = [node]
      node   = new OperatorNode(name, fn, params)

    node

  ###
  # Parse a custom node handler. A node handler can be used to process
  # nodes in a custom way, for example for handling a plot.
  # 
  # A handler must be defined in the namespace erdos.expression.node.handlers,
  # and must extend erdos.expression.node.Node, and the handler must contain
  # functions eval(), find(filter), and toString().
  # 
  # For example:
  # 
  # erdos.expression.node.handlers['plot'] = PlotHandler;
  # 
  # The constructor of the handler is called as:
  # 
  # node = new PlotHandler(params, paramScopes);
  # 
  # The handler will be invoked when evaluating an expression like:
  # 
  # node = erdos.parse('plot(sin(x), x)');
  # 
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseNodeHandler: (scope) ->
    params      = undefined
    paramScopes = undefined
    paramScope  = undefined
    handler     = undefined

    if @token_type is Lexer.TOKENTYPE.SYMBOL and handlers[@token]
      handler = handlers[@token]
      @getToken()
      
      # parse parameters
      if @token is "("
        params      = []
        paramScopes = []

        @getToken()

        unless @token is ")"
          paramScope = scope.createSubScope()

          paramScopes.push paramScope
          params.push @parseRange(paramScope)
          
          # parse a list with parameters
          while @token is ","
            @getToken()
            paramScope = scope.createSubScope()
            paramScopes.push paramScope
            params.push parseRange(paramScope)

        throw new SyntaxError("Parenthesis ) expected") unless @token is ")"

        @getToken()
      
      # create a new node handler
      #noinspection JSValidateTypes
      return new handler(params, paramScopes)

    @parseSymbol scope

  ###
  # parse symbols: functions, variables, constants, units
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseSymbol: (scope) ->
    node = undefined
    name = undefined

    if @token_type is Lexer.TOKENTYPE.SYMBOL or (@token_type is Lexer.TOKENTYPE.DELIMITER and @token of Lexer.NAMED_DELIMITERS)
      name = @token

      @getToken()
      
      # create a symbol
      node = new SymbolNode(name, scope)
      
      # parse parameters
      return @parseParams(scope, node)

    @parseString scope

  ###
  # parse parameters, enclosed in parenthesis
  # @param {Scope} scope
  # @param {Node} node    Node on which to apply the parameters. If there
  # are no parameters in the expression, the node
  # itself is returned
  # @return {Node} node
  # @private
  ###
  parseParams: (scope, node) ->
    bracket     = undefined
    params      = undefined
    paramScopes = undefined
    paramScope  = undefined

    while @token is "("
      bracket     = @token
      params      = []
      paramScopes = []

      @getToken()
      unless @token is ")"

        paramScope = scope.createSubScope()
        paramScopes.push paramScope
        params.push @parseRange(paramScope)
        
        # parse a list with parameters
        while @token is ","
          @getToken()
          paramScope = scope.createSubScope()
          paramScopes.push paramScope
          params.push @parseRange(paramScope)

      throw new SyntaxError("Parenthesis ) expected") if bracket is "(" and @token isnt ")"

      @getToken()
      node = new ParamsNode(@erdos, node, params, paramScopes)

    node

  ###
  # parse a string.
  # A string is enclosed by double quotes
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseString: (scope) ->
    node  = undefined
    str   = undefined
    tPrev = undefined

    if @token is "\""
      
      # string "..."
      str   = ""
      tPrev = ""

      while @c isnt "" and (c isnt "\"" or tPrev is "\\") # also handle escape character
        str  += @c
        tPrev = @c
        @next()

      @getToken()

      throw new SyntaxError("End of string \" expected") unless @token is "\""

      @getToken()
      
      # create constant
      node = new ConstantNode(str)
      
      # parse parameters
      node = @parseParams(scope, node)
      return node

    @parseMatrix scope

  ###
  # parse the matrix
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseMatrix: (scope) ->
    array  = undefined
    params = undefined
    rows   = undefined
    cols   = undefined

    if @token is "["
      # matrix [...]
      
      # skip newlines
      @getToken()
      @getToken() while @token is "\n"

      unless @token is "]"
        
        # this is a non-empty matrix
        row = @parseRow(scope)
        if @token is ";"
          
          # 2 dimensional array
          rows   = 1
          params = [row]
          
          # the rows of the matrix are separated by dot-comma's
          while @token is ";"
            @getToken()
            
            # skip newlines
            @getToken() while @token is "\n"
            params[rows] = @parseRow(scope)
            rows++
            
            # skip newlines
            @getToken() while @token is "\n"

          throw new SyntaxError("End of matrix ] expected") unless @token is "]"
          @getToken()
          
          # check if the number of columns matches in all rows
          cols = (if (params.length > 0) then params[0].length else 0)
          r    = 1

          while r < rows
            throw new Error("Number of columns must match " + "(" + params[r].length + " != " + cols + ")") unless params[r].length is cols
            r++
          array = new ArrayNode(@settings, params)
        else
          
          # 1 dimensional vector
          throw new SyntaxError("End of matrix ] expected")  unless @token is "]"
          @getToken()
          array = row
      else 
        # this is an empty matrix "[ ]"
        @getToken()
        array = new ArrayNode(@settings, [])
      
      # parse parameters
      array = @parseParams(scope, array)
      return array

    @parseNumber scope

  ###
  # Parse a single comma-separated row from a matrix, like 'a, b, c'
  # @param {Scope} scope
  # @return {ArrayNode} node
  ###
  parseRow: (scope) ->
    params = [@parseAssignment(scope)]
    len    = 1

    while @token is ","
      @getToken()
      
      # skip newlines
      @getToken() while @token is "\n"
      
      # parse expression
      params[len] = @parseAssignment(scope)
      len++
      
      # skip newlines
      @getToken() while @token is "\n"

    new ArrayNode(@settings, params)

  ###
  # parse a number
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseNumber: (scope) ->
    node   = undefined
    value  = undefined
    number = undefined

    if @token_type is Lexer.TOKENTYPE.NUMBER
      
      # this is a number
      if @settings.number is "bignumber"
        # parse a big number
        number = new BigNumber((if (@token is ".") then 0 else @token))
      else
        # parse a regular number
        number = (if (@token is ".") then 0 else Number(@token))

      @getToken()

      if @token is "i" or @token is "I"
        # create a complex number
        
        # convert bignumber to number as Complex doesn't support BigNumber
        number = (if (number instanceof BigNumber) then toNumber(number) else number)
        value  = new Complex(0, number)

        @getToken()

        node = new ConstantNode(value)
      else
        # a real number
        node = new ConstantNode(number)
      
      # parse parameters
      node = @parseParams(scope, node)
      return node

    @parseParentheses scope

  ###
  # parentheses
  # @param {Scope} scope
  # @return {Node} node
  # @private
  ###
  parseParentheses: (scope) ->
    node = undefined
    
    # check if it is a parenthesized expression
    if @token is "("
      # parentheses (...)
      @getToken()

      node = @parseAssignment(scope) # start again

      throw new SyntaxError("Parenthesis ) expected") unless @token is ")"

      @getToken()
      
      # TODO: implicit multiplication?
      #       // TODO: how to calculate a=3; 2/2a ? is this (2/2)*a or 2/(2*a) ?
      #       // check for implicit multiplication
      #       if (@token_type == Lexer.TOKENTYPE.SYMBOL) {
      #       node = multiply(node, parsePow());
      #       }
      #       //
      
      # parse parameters
      node = @parseParams(scope, node)
      return node

    @parseEnd scope

  ###
  # Evaluated when the expression is not yet ended but expected to end
  # @param {Scope} scope
  # @return {Node} res
  # @private
  ###
  parseEnd: (scope) ->
    if @token is ""
      # syntax error or unexpected end of expression
      throw new SyntaxError("Unexpected end of expression")
    else
      throw new SyntaxError("Value expected")

module?.exports = Parser
