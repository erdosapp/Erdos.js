object = require('./util/object')
Erdos  = require('./type/Erdos')

###
# erdos.js factory function.
# 
# Usage:
# 
# var erdos = erdosjs();
# var erdos = erdosjs(settings);
# 
# @param {Object} [settings] Available settings:
# {String} matrix
# A string 'matrix' (default) or 'array'.
# {String} number
# A string 'number' (default) or 'bignumber'
# {Number} decimals
# The number of decimals behind the decimal
# point for BigNumber. Not applicable for Numbers.
###
erdos = (settings) ->  
  # simple test for ES5 support
  if typeof Array::map isnt "function"
    throw new Error("ES5 not supported by this JavaScript engine. " + "Please load the es5-shim library for compatibility.") 
  
  # create new namespace
  erdos = new Erdos()
  erdos.Erdos = Erdos
  
  # create configuration settings. These are private
  _settings =

    # type of default matrix output. Choose 'matrix' (default) or 'array'
    matrix: "matrix"

    # type of default number output. Choose 'number' (default) or 'bignumber'
    number: "number"

  ###
  # Set configuration settings for erdos.js, and get current settings
  # @param {Object} [settings] Available settings:
  # {String} matrix
  # A string 'matrix' (default) or 'array'.
  # {String} number
  # A string 'number' (default) or 'bignumber'
  # {Number} decimals
  # The number of decimals behind the decimal
  # point for BigNumber. Not applicable for Numbers.
  # @return {Object} settings   The currently applied settings
  ###
  erdos.config = (settings) ->
    BigNumber = require("bignumber.js")
    if settings
      
      # merge settings
      object.deepExtend _settings, settings
      BigNumber.config DECIMAL_PLACES: settings.decimals if settings.decimals
      
      # TODO: remove deprecated setting some day (deprecated since version 0.17.0)
      throw new Error("setting `number.defaultType` is deprecated. " + "Use `number` instead.")  if settings.number and settings.number.defaultType
      
      # TODO: remove deprecated setting some day (deprecated since version 0.17.0)
      throw new Error("setting `number.precision` is deprecated. " + "Use `decimals` instead.")  if settings.number and settings.number.precision
      
      # TODO: remove deprecated setting some day (deprecated since version 0.17.0)
      throw new Error("setting `matrix.defaultType` is deprecated. " + "Use `matrix` instead.")  if settings.matrix and settings.matrix.defaultType
      
      # TODO: remove deprecated setting some day (deprecated since version 0.15.0)
      throw new Error("setting `matrix.default` is deprecated. " + "Use `matrix` instead.")  if settings.matrix and settings.matrix["default"]
    
    # return a clone of the settings
    current = object.clone(_settings)
    current.decimals = BigNumber.config().DECIMAL_PLACES
    current

  # apply provided configuration settings
  erdos.settings = erdos.config(settings)

  # Constants
  require("./constants")(erdos, settings)

  # Core. Lexer, Parser, Evaluator
  erdos.Evaluator = require("./core/Evaluator")
  erdos.Lexer     = require("./core/Lexer")
  erdos.Parser    = require("./core/Parser")
  erdos.Scope     = require("./core/Scope")

  # Node
  erdos.node = require("./expression/node/index")

  # types (Matrix, Complex, Unit, ...)
  erdos.BigNumber  = require("bignumber.js")
  erdos.Complex    = require("./type/Complex")
  erdos.Range      = require("./type/Range")
  erdos.Index      = require("./type/Index")
  erdos.Matrix     = require("./type/Matrix")
  erdos.Unit       = require("./type/Unit")
  erdos.Collection = require("./type/Collection")
  
  # error utility functions
  erdos.error = require("./type/Error")
  
  # functions - arithmetic
  require("./function/arithmetic/abs")(erdos, erdos.settings)
  require("./function/arithmetic/add")(erdos, erdos.settings)
  require("./function/arithmetic/ceil")(erdos, erdos.settings)
  require("./function/arithmetic/cube")(erdos, erdos.settings)
  require("./function/arithmetic/divide")(erdos, erdos.settings)
  require("./function/arithmetic/edivide")(erdos, erdos.settings)
  require("./function/arithmetic/emultiply")(erdos, erdos.settings)
  require("./function/arithmetic/epow")(erdos, erdos.settings)
  require("./function/arithmetic/equal")(erdos, erdos.settings)
  require("./function/arithmetic/exp")(erdos, erdos.settings)
  require("./function/arithmetic/fix")(erdos, erdos.settings)
  require("./function/arithmetic/floor")(erdos, erdos.settings)
  require("./function/arithmetic/gcd")(erdos, erdos.settings)
  require("./function/arithmetic/larger")(erdos, erdos.settings)
  require("./function/arithmetic/largereq")(erdos, erdos.settings)
  require("./function/arithmetic/lcm")(erdos, erdos.settings)
  require("./function/arithmetic/log")(erdos, erdos.settings)
  require("./function/arithmetic/log10")(erdos, erdos.settings)
  require("./function/arithmetic/mod")(erdos, erdos.settings)
  require("./function/arithmetic/multiply")(erdos, erdos.settings)
  require("./function/arithmetic/pow")(erdos, erdos.settings)
  require("./function/arithmetic/round")(erdos, erdos.settings)
  require("./function/arithmetic/sign")(erdos, erdos.settings)
  require("./function/arithmetic/smaller")(erdos, erdos.settings)
  require("./function/arithmetic/smallereq")(erdos, erdos.settings)
  require("./function/arithmetic/sqrt")(erdos, erdos.settings)
  require("./function/arithmetic/square")(erdos, erdos.settings)
  require("./function/arithmetic/subtract")(erdos, erdos.settings)
  require("./function/arithmetic/unary")(erdos, erdos.settings)
  require("./function/arithmetic/unequal")(erdos, erdos.settings)
  require("./function/arithmetic/xgcd")(erdos, erdos.settings)
  
  # functions - complex
  erdos.arg  = require("./function/complex/arg")
  erdos.conj = require("./function/complex/conj")
  erdos.re   = require("./function/complex/re")
  erdos.im   = require("./function/complex/im")
  
  # functions - construction
  erdos.bignumber = require("./function/construction/bignumber")
  erdos.boolean   = require("./function/construction/boolean")
  erdos.complex   = require("./function/construction/complex")
  erdos.index     = require("./function/construction/index")
  erdos.matrix    = require("./function/construction/matrix")
  erdos.number    = require("./function/construction/number")
  require("./function/construction/select")(erdos, erdos.settings)
  erdos.string    = require("./function/construction/string")
  erdos.unit      = require("./function/construction/unit")
  require("./function/construction/parser")(erdos, erdos.settings)

  # functions - matrix
  require("./function/matrix/concat")(erdos, erdos.settings)
  require("./function/matrix/det")(erdos, erdos.settings)
  require("./function/matrix/diag")(erdos, erdos.settings)
  require("./function/matrix/eye")(erdos, erdos.settings)
  require("./function/matrix/inv")(erdos, erdos.settings)
  require("./function/matrix/ones")(erdos, erdos.settings)
  require("./function/matrix/range")(erdos, erdos.settings)
  require("./function/matrix/resize")(erdos, erdos.settings)
  require("./function/matrix/size")(erdos, erdos.settings)
  require("./function/matrix/squeeze")(erdos, erdos.settings)
  require("./function/matrix/subset")(erdos, erdos.settings)
  require("./function/matrix/transpose")(erdos, erdos.settings)
  require("./function/matrix/zeros")(erdos, erdos.settings)
  
  # functions - probability
  erdos.factorial = require("./function/probability/factorial")
  erdos.random    = require("./function/probability/random")(erdos, erdos.settings)
  
  # functions - statistics
  require("./function/statistics/min")(erdos, erdos.settings)
  require("./function/statistics/max")(erdos, erdos.settings)
  require("./function/statistics/mean")(erdos, erdos.settings)
  
  # functions - trigonometry
  require("./function/trigonometry/acos")(erdos, erdos.settings)
  require("./function/trigonometry/asin")(erdos, erdos.settings)
  require("./function/trigonometry/atan")(erdos, erdos.settings)
  require("./function/trigonometry/atan2")(erdos, erdos.settings)
  require("./function/trigonometry/cos")(erdos, erdos.settings)
  require("./function/trigonometry/cot")(erdos, erdos.settings)
  require("./function/trigonometry/csc")(erdos, erdos.settings)
  require("./function/trigonometry/sec")(erdos, erdos.settings)
  require("./function/trigonometry/sin")(erdos, erdos.settings)
  require("./function/trigonometry/tan")(erdos, erdos.settings)
  
  # functions - units
  require("./function/units/in")(erdos, erdos.settings)
  
  # functions - utils
  erdos.clone   = require("./function/util/clone")
  erdos.format  = require("./function/util/format")
  erdos.import  = require("./function/util/import")(erdos, erdos.settings)
  erdos.map     = require("./function/util/map")
  require("./function/util/print")(erdos, erdos.settings)
  require("./function/util/typeof")(erdos, erdos.settings)
  erdos.forEach = require("./function/util/forEach")
  
  # selector (we initialize after all functions are loaded)
  erdos.chaining = {}
  erdos.chaining.Selector = require("./chaining/Selector")(erdos)

  erdos.parse = require('./expression/parse')
  erdos.eval  = require('./expression/eval')

  # return the new instance
  erdos

module.exports = erdos
