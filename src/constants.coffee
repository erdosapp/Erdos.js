module.exports = (erdos, settings) ->
  Complex           = require("./type/Complex")
  erdos.pi          = Math.PI
  erdos.e           = Math.E
  erdos.tau         = Math.PI * 2
  erdos.i           = new Complex(0, 1)
  erdos["Infinity"] = Infinity
  erdos["NaN"]      = NaN
  erdos["true"]     = true
  erdos["false"]    = false
  
  # uppercase constants (for compatibility with built-in Math)
  erdos.E        = Math.E
  erdos.LN2      = Math.LN2
  erdos.LN10     = Math.LN10
  erdos.LOG2E    = Math.LOG2E
  erdos.LOG10E   = Math.LOG10E
  erdos.PI       = Math.PI
  erdos.SQRT1_2  = Math.SQRT1_2
  erdos.SQRT2    = Math.SQRT2
