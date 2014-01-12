module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  object    = util.Object
  isArray   = Array.isArray
  isNumber  = util.Number.isNumber
  isInteger = util.Number.isInteger

  ###
  # Create a diagonal matrix or retrieve the diagonal of a matrix
  # 
  # diag(v)
  # diag(v, k)
  # diag(X)
  # diag(X, k)
  # 
  # TODO: more documentation on diag
  # 
  # @param {Matrix | Array} x
  # @param {Number} [k]
  # @return {Matrix | Array} matrix
  ###
  diag = (x, k) ->
    data   = undefined
    vector = undefined
    i      = undefined
    iMax   = undefined

    throw new error.ArgumentsError("diag", arguments.length, 1, 2)  if arguments.length isnt 1 and arguments.length isnt 2
    if k
      throw new TypeError("Second parameter in function diag must be an integer")  if not isNumber(k) or not isInteger(k)
    else
      k = 0
    kSuper = (if k > 0 then k else 0)
    kSub = (if k < 0 then -k else 0)
    
    # check type of input
    if x instanceof Matrix
    
    # nice, nothing to do
    else if isArray(x)
      
      # convert to matrix
      x = new Matrix(x)
    else
      throw new TypeError("First parameter in function diag must be a Matrix or Array")
    s = x.size()
    switch s.length
      when 1
        
        # x is a vector. create diagonal matrix
        vector = x.valueOf()
        matrix = new Matrix()
        defaultValue = 0
        matrix.resize [vector.length + kSub, vector.length + kSuper], defaultValue
        data = matrix.valueOf()
        iMax = vector.length
        i = 0
        while i < iMax
          data[i + kSub][i + kSuper] = object.clone(vector[i])
          i++
        return (if (settings.matrix is "array") then matrix.valueOf() else matrix)
      when 2
        
        # x is a matrix get diagonal from matrix
        vector = []
        data = x.valueOf()
        iMax = Math.min(s[0] - kSub, s[1] - kSuper)
        i = 0
        while i < iMax
          vector[i] = object.clone(data[i + kSub][i + kSuper])
          i++
        return (if (settings.matrix is "array") then vector else new Matrix(vector))
      else
        throw new RangeError("Matrix for function diag must be 2 dimensional")

  erdos.diag = diag
