class Lexer
  # token types enumeration
  @TOKENTYPE:
    NULL: 0
    DELIMITER: 1
    NUMBER: 2
    SYMBOL: 3
    UNKNOWN: 4

  @KEYWORDS: ["in", "to", "of"]

  # map with all delimiters
  @DELIMITERS:
    ",": true
    "(": true
    ")": true
    "[": true
    "]": true
    "\"": true
    "\n": true
    ";": true
    "+": true
    "-": true
    "*": true
    ".*": true
    "/": true
    "./": true
    "$": true
    "%": true
    "^": true
    ".^": true
    "!": true
    "'": true
    "=": true
    ":": true
    "==": true
    "!=": true
    "<": true
    ">": true
    "<=": true
    ">=": true

  # map with all named delimiters
  @NAMED_DELIMITERS:
    mod: true
    in: true
  
  constructor: (exp = "") ->
    @setInput(exp)

  ###
  # Sets the starting point
  ###
  setInput: (exp = "") ->
    @expression = exp # current expression
    @index      = 0 # current index in expr
    @c          = "" # current token character in expr
    @token      = "" # current token
    @token_type = Lexer.TOKENTYPE.NULL # type of the token
 
  ### 
  # Set expressions
  ###
  setExpression: (exp = "") ->
    @expression = exp 

  ###
  # Turns everything into tokens
  ###
  go: ->
    @first()
    tokens = [ ]
    while @index < @expression.length
      tokens.push @getToken()

    return tokens

  ###
  # Get the first character from the expression.
  # The character is stored into the char c. If the end of the expression is
  # reached, the function puts an empty string in c.
  # @private
  ###
  first: ->
    @index = 0
    @c     = @expression.charAt(0)

  ###
  # Get the next character from the expression.
  # The character is stored into the char c. If the end of the expression is
  # reached, the function puts an empty string in c.
  # @private
  ###
  next: ->
    @index++
    @c = @expression.charAt(@index)

  ###
  # Preview the next character from the expression.
  # @return {String} cNext
  # @private
  ###
  nextPreview: ->
    @expression.charAt(@index + 1)

  ###
  # Get next token in the current string expr.
  # The token and token type are available as token and token_type
  # @private
  ###
  getToken: ->
    @token_type = Lexer.TOKENTYPE.NULL
    @token      = ""
    
    # skip over whitespaces
    # space or tab
    @next() while @c is " " or @c is "\t"
    
    # skip comment
    @next() while @c isnt "\n" and @c isnt "" if @c is "#"
    
    # check for end of expression
    if @c is ""
      # token is still empty
      @token_type = Lexer.TOKENTYPE.DELIMITER

      return type: @token_type, value: @token

    # check for delimiters consisting of 2 characters
    c2 = @c + @nextPreview()
    if Lexer.DELIMITERS[c2]
      @token_type = Lexer.TOKENTYPE.DELIMITER
      @token = c2
      @next()
      @next()

      return type: @token_type, value: @token

    # check for delimiters consisting of 1 character
    if Lexer.DELIMITERS[@c]
      @token_type = Lexer.TOKENTYPE.DELIMITER
      @token = @c
      @next()

      return type: @token_type, value: @token

    # check for a number
    if @isDigitDot(@c)
      @token_type = Lexer.TOKENTYPE.NUMBER
      
      # get number, can have a single dot
      if @c is "."
        @token += @c
        @next()
        
        # this is no legal number, it is just a dot
        @token_type = Lexer.TOKENTYPE.UNKNOWN unless @isDigit(c)
      else
        while @isDigit(@c)
          @token += @c
          @next()
        if @c is "."
          @token += @c
          @next()

      while @isDigit(@c)
        @token += @c
        @next()
      
      # check for exponential notation like "2.3e-4" or "1.23e50"
      if @c is "E" or @c is "e"
        @token += @c
        @next()
        if @c is "+" or @c is "-"
          @token += @c
          @next()
        
        # Scientific notation MUST be followed by an exponent
        
        # this is no legal number, exponent is missing.
        @token_type = Lexer.TOKENTYPE.UNKNOWN  unless isDigit(@c)
        while @isDigit(@c)
          @token += @c
          @next()

      return type: @token_type, value: @token

    # check for variables, functions, named operators
    if @isAlpha(@c)
      while @isAlpha(@c) or @isDigit(@c)
        @token += @c
        @next()
      if Lexer.NAMED_DELIMITERS[@token]
        @token_type = Lexer.TOKENTYPE.DELIMITER
      else
        @token_type = Lexer.TOKENTYPE.SYMBOL

      return type: @token_type, value: @token

    # something unknown is found, wrong characters -> a syntax error
    @token_type = Lexer.TOKENTYPE.UNKNOWN

    while @c isnt ''
      @token += @c
      @next()

    return type: @token_type, value: @token
      
  ###
  # Check if a given name is valid
  # if not, an error is thrown
  # @param {String} name
  # @return {boolean} valid
  # @private
  # TODO: check for valid symbol name
  ###
  isValidSymbolName: (name) ->
    i    = 0
    iMax = name.length

    while i < iMax
      @c = name.charAt(i)
      
      #var valid = (isAlpha(c) || (i > 0 && isDigit(c))); // TODO: allow digits in symbol name
      valid = (@isAlpha(@c))
      return false unless valid
      i++

    true

  ###
  # checks if the given char c is a letter (upper or lower case)
  # or underscore
  # @param {String} c   a string with one character
  # @return {Boolean}
  # @private
  ###
  isAlpha: (c) ->
    (c >= "a" and c <= "z") or (c >= "A" and c <= "Z") or c is "_"

  ###
  # checks if the given char c is a digit or dot
  # @param {String} c   a string with one character
  # @return {Boolean}
  # @private
  ###
  isDigitDot: (c) ->
    (c >= "0" and c <= "9") or c is "."

  ###
  # checks if the given char c is a digit
  # @param {String} c   a string with one character
  # @return {Boolean}
  # @private
  ###
  isDigit: (c) ->
    c >= "0" and c <= "9"

  ###
  # Shortcut for getting the current row value (one based)
  # Returns the line of the currently handled expression
  # @private
  ###
  row: ->
    # TODO: also register row number during parsing
    undefined

  ###
  # Shortcut for getting the current col value (one based)
  # Returns the column (position) where the last token starts
  # @private
  ###
  col: ->
    @index - @token.length + 1
  
  ###
  # Get a variable (a function or variable) by name from the parsers scope.
  # Returns undefined when not found
  # @param {String} name
  # @return {* | undefined} value
  ###
  get: (name) ->
    # TODO: validate arguments
    @scope.get name

  ###
  # Set a symbol (a function or variable) by name from the parsers scope.
  # @param {String} name
  # @param {* | undefined} value
  ###
  set: (name, value) ->
    
    # TODO: validate arguments
    @scope.set name, value

  ###
  # Remove a variable from the parsers scope
  # @param {String} name
  ###
  remove: (name) ->
    # TODO: validate arguments
    @scope.remove name

  ###
  # Clear the scope with variables and functions
  ###
  clear: ->
    @scope.clear()

module.exports = Lexer
