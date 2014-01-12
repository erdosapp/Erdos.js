module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber  = require('bignumber.js')
  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  toNumber  = util.Number.toNumber
  isNumber  = util.Number.isNumber
  isInteger = util.Number.isInteger
  isArray   = Array.isArray
  
  ###
  # Create a 2-dimensional identity matrix with size m x n or n x n
  # 
  # eye(n)
  # eye(m, n)
  # eye([m, n])
  # 
  # TODO: more documentation on eye
  # 
  # @param {...Number | Matrix | Array} size
  # @return {Matrix | Array | Number} matrix
  ###
  eye = (size) ->
    args = collection.argsToArray(arguments)
    asMatrix = (if (size instanceof Matrix) then true else ((if isArray(size) then false else (settings.matrix is "matrix"))))

    if args.length is 0     
      # return an empty array
      return (if asMatrix then new Matrix() else [])
    else if args.length is 1
      
      # change to a 2-dimensional square
      args[1] = args[0]
    
    # error in case of an n-dimensional size
    else throw new error.ArgumentsError("eye", args.length, 0, 2)  if args.length > 2
    asBigNumber = args[0] instanceof BigNumber
    rows = args[0]
    cols = args[1]
    rows = toNumber(rows)  if rows instanceof BigNumber
    cols = toNumber(cols)  if cols instanceof BigNumber
    throw new Error("Parameters in function eye must be positive integers")  if not isNumber(rows) or not isInteger(rows) or rows < 1
    throw new Error("Parameters in function eye must be positive integers")  if not isNumber(cols) or not isInteger(cols) or cols < 1  if cols
    
    # create and args the matrix
    matrix = new Matrix()
    one = (if asBigNumber then new BigNumber(1) else 1)
    defaultValue = (if asBigNumber then new BigNumber(0) else 0)
    matrix.resize args.map(toNumber), defaultValue
    
    # fill in ones on the diagonal
    minimum = erdos.min(args)
    data = matrix.valueOf()
    d = 0

    while d < minimum
      data[d][d] = one
      d++
    (if asMatrix then matrix else matrix.valueOf())
  
  erdos.eye = eye