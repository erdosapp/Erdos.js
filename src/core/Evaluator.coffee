erdosjs = require('../erdos')
error   = require('../type/Error')

Parser  = require('./Parser')
Scope   = require('./Scope')

util = require('../util/index')

collection = require('../type/Collection')
isString   = util.String.isString
isCollection = collection.isCollection

class Evaluator 
  constructor: (expr, scope, erdos=null) ->
    unless arguments.length > 1 
      throw new error.ArgumentsError("eval", arguments.length, 1, 2) 

    unless erdos 
      erdos = erdosjs()

    @erdos = erdos
    
    # instantiate a scope
    @evalScope = undefined
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

    @expr   = expr
    @parser = new Parser(@expr, @scope, @erdos)

  go: ->
    return @parser.go().eval()

module.exports = Evaluator
