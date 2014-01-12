module.exports = (erdos, settings) ->
  util  = require('../../util/index')
  error = require('../../type/Error')

  BigNumber   = require('bignumber.js')
  Matrix     = require('../../type/Matrix')
  collection = require('../../type/Collection')

  array = util.Array

  toNumber = util.Number.toNumber
  isArray  = Array.isArray

  ###
  # Create a matrix filled with ones
  # 
  # ones(m)
  # ones(m, n)
  # ones([m, n])
  # ones([m, n, p, ...])
  # 
  # @param {...Number | Array} size
  # @return {Array | Matrix | Number} matrix
  ###
  ones = (size) ->
    args = collection.argsToArray(arguments)
    asMatrix = (if (size instanceof Matrix) then true else ((if isArray(size) then false else (settings.matrix is "matrix"))))
    if args.length is 0
      
      # output an empty matrix
      (if asMatrix then new Matrix() else [])
    else
      
      # output an array or matrix
      res = []
      defaultValue = (if (args[0] instanceof BigNumber) then new BigNumber(1) else 1)
      res = array.resize(res, args.map(toNumber), defaultValue)
      (if asMatrix then new Matrix(res) else res)
  
  erdos.ones = ones
