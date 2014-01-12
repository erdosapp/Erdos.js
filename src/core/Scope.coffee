erdosjs = require('../erdos')
Unit    = require('../type/Unit')
Erdos   = require('../type/Erdos')

class Scope
  ###
  # Scope
  # A scope stores values of symbols: variables and functions.
  # 
  # Syntax:
  # var scope = new Scope(math);
  # var scope = new Scope(math, parentScope);
  # var scope = new Scope(math, symbols);
  # var scope = new Scope(math, parentScope, symbols);
  # 
  # Where:
  # {Object} math                Link to the (static) math.js namespace
  # {Scope | Object} parentScope Scope will be linked to a parent scope,
  # which is traversed when resolving
  # symbols.
  # {Object} symbols             A custom object that will be used to
  # resolve and store variables.
  # 
  # @constructor Scope
  # @param {...} [math]
  # @param {*} [arg1]
  # @param {*} [arg2]
  ###
  constructor: (arg1, arg2, arg3) ->
    erdos = arg1 if arg1 instanceof Erdos
    erdos = arg2 if arg2 instanceof Erdos
    erdos = arg3 if arg3 instanceof Erdos

    unless erdos
      erdos = erdosjs()

    @erdos = erdos

    @parentScope = null
        
    @subScopes = null
    @symbols   = {} # variables and functions
    @cache     = {} # cache, referring to the scope.symbols object where
    
    # read second argument (can be parentScope or symbols map)
    if arg1 and arg1 not instanceof erdos.Erdos
      if arg1 instanceof Scope
        @parentScope = arg1
      else @symbols = arg1 if arg1 instanceof Object
    
    if arg2 and arg2 not instanceof erdos.Erdos
      if arg2 instanceof Scope
        @parentScope = arg2
      else @symbols = arg2 if arg2 instanceof Object

    if arg3 and arg3 not instanceof erdos.Erdos
      if arg3 instanceof Scope
        @parentScope = arg3
      else @symbols = arg3 if arg3 instanceof Object

    # read second argument (can be symbols map)
    if arg2
      @symbols = arg2 if arg2 instanceof Object and arg2 not instanceof Erdos

    if arg3
      @symbols = arg3 if arg3 instanceof Object and arg3 not instanceof Erdos

  ###
  # Create a sub scope
  # The variables in a sub scope are not accessible from the parent scope
  # @return {Scope} subScope
  ###
  createSubScope: ->
    subScope   = new Scope(this, @erdos)
    @subScopes = [] unless @subScopes
    @subScopes.push subScope
    subScope
  
  ###
  # Get a symbol value by name.
  # Returns undefined if the symbol is not found in this scope or any of
  # its parent scopes.
  # @param {String} name
  # @returns {* | undefined} value
  ###
  get: (name) ->
    value = undefined
    
    # check itself
    value = @symbols[name]
    return value if value isnt undefined
    
    # read from cache
    symbols = @cache[name]
    return symbols[name]  if symbols
    
    # check parent scope
    parent = @parentScope
    while parent
      value = parent.symbols[name]
      if value isnt undefined
        @cache[name] = parent.symbols
        return value
      parent = parent.parentScope
    
    # check static context
    if @erdos
      value = @erdos[name]
      if value isnt undefined
        @cache[name] = @erdos
        return value
      
    # check if name is a unit
    if Unit.isPlainUnit(name)
      value = new Unit(null, name)
      @cache[name] = {}
      @cache[name][name] = value
      return value
    undefined
  
  ###
  # Test whether this scope contains a symbol (will not check parent scopes)
  # @param {String} name
  # @return {Boolean} hasSymbol
  ###
  has: (name) ->
    @symbols[name] isnt undefined
  
  ###
  # Set a symbol value
  # @param {String} name
  # @param {*} value
  # @return {*} value
  ###
  set: (name, value) ->
    @symbols[name] = value

  ###
  # Remove a symbol by name
  # @param {String} name
  ###
  remove: (name) ->
    delete @symbols[name]
  
  ###
  # Clear all symbols in this scope, its sub scopes, and clear the cache.
  # Parent scopes will not be cleared.
  ###
  clear: ->
    symbols = @symbols
    for name of symbols
      delete symbols[name]  if symbols.hasOwnProperty(name)
    if @subScopes
      subScopes = @subScopes
      i = 0
      iMax = subScopes.length

      while i < iMax
        subScopes[i].clear()
        i++
    @clearCache()
  
  ###
  # Clear cached links to symbols in other scopes
  ###
  clearCache: ->
    @cache = {}

Scope.context   = [] # static context, for example the math namespace
module?.exports = Scope
