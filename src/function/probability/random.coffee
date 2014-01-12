error = require('../../type/Error')

Matrix     = require('../../type/Matrix')
collection = require('../../type/Collection')

distribution         = undefined
uniformRandFunctions = undefined

module.exports = (erdos, settings) ->
  # TODO: implement BigNumber support for random

  ###
  # Return a random number between 0 and 1
  # 
  # random()
  # 
  # @return {Number} res
  ###

  # Each distribution is a function that takes no argument and when called returns
  # a number between 0 and 1.
  distributions =
    uniform: ->
      Math.random

    # Implementation of normal distribution using Box-Muller transform
    # ref : http://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
    # We take : mean = 0.5, standard deviation = 1/6
    # so that 99.7% values are in [0, 1].
    normal: ->
      ->
        u1 = undefined
        u2 = undefined
        picked = -1
        
        # We reject values outside of the interval [0, 1]
        # TODO: check if it is ok to do that?
        while picked < 0 or picked > 1
          u1 = Math.random()
          u2 = Math.random()
          picked = 1 / 6 * Math.pow(-2 * Math.log(u1), 0.5) * Math.cos(2 * Math.PI * u2) + 0.5
        picked

  ###
  # Create a distribution object.
  # @param {String} name           Name of a distribution.
  # Choose from 'uniform', 'normal'.
  # @return {Object} distribution  A distribution object containing functions:
  # random([size, min, max])
  # randomInt([min, max])
  # pickRandom(array)
  ###
  erdos.distribution = (name) ->
    throw new Error("unknown distribution " + name)  unless distributions.hasOwnProperty(name)
    args = Array::slice.call(arguments, 1)
    distribution = distributions[name].apply(this, args)
    ((distribution) ->
      
      # This is the public API for all distributions
      randFunctions =
        random: (arg1, arg2, arg3) ->
          size = undefined
          min = undefined
          max = undefined
          if arguments.length > 3
            throw new error.ArgumentsError("random", arguments.length, 0, 3)
          
          # `random(max)` or `random(size)`
          else if arguments.length is 1
            if Array.isArray(arg1)
              size = arg1
            else
              max = arg1
          
          # `random(min, max)` or `random(size, max)`
          else if arguments.length is 2
            unless Array.isArray(arg1)
              min = arg1
              max = arg2
          
          # `random(size, min, max)`
          else
            size = arg1
            min = arg2
            max = arg3
          max = 1  if max is undefined
          min = 0  if min is undefined
          if size isnt undefined
            res = _randomDataForMatrix(size, min, max, _random)
            (if (settings.matrix is "array") then res else new Matrix(res))
          else
            _random min, max

        randomInt: (arg1, arg2, arg3) ->
          size = undefined
          min = undefined
          max = undefined
          if arguments.length > 3 or arguments.length < 1
            throw new error.ArgumentsError("randomInt", arguments.length, 1, 3)
          
          # `randomInt(max)`
          else if arguments.length is 1
            max = arg1
          
          # `randomInt(min, max)` or `randomInt(size, max)`
          else if arguments.length is 2
            unless Object::toString.call(arg1) is "[object Array]"
              min = arg1
              max = arg2
          
          # `randomInt(size, min, max)`
          else
            size = arg1
            min = arg2
            max = arg3
          min = 0  if min is undefined
          if size isnt undefined
            res = _randomDataForMatrix(size, min, max, _randomInt)
            (if (settings.matrix is "array") then res else new Matrix(res))
          else
            _randomInt min, max

        pickRandom: (possibles) ->
          throw new error.ArgumentsError("pickRandom", arguments.length, 1)  if arguments.length isnt 1
          throw new error.UnsupportedTypeError("pickRandom", possibles)  unless Array.isArray(possibles)
          
          # TODO: add support for matrices
          possibles[Math.floor(Math.random() * possibles.length)]

      _random = (min, max) ->
        min + distribution() * (max - min)

      _randomInt = (min, max) ->
        Math.floor min + distribution() * (max - min)

      # This is a function for generating a random matrix recursively.
      _randomDataForMatrix = (size, min, max, randFunc) ->
        data = []
        length = undefined
        i = undefined
        size = size.slice(0)
        if size.length > 1
          i = 0
          length = size.shift()

          while i < length
            data.push _randomDataForMatrix(size, min, max, randFunc)
            i++
        else
          i = 0
          length = size.shift()

          while i < length
            data.push randFunc(min, max)
            i++
        data

      randFunctions
    ) distribution

  # Default random functions use uniform distribution
  # TODO: put random functions in separate files?
  exports.uniformRandFunctions = erdos.distribution("uniform")
  erdos.random                 = exports.uniformRandFunctions.random
  erdos.randomInt              = exports.uniformRandFunctions.randomInt
  erdos.pickRandom             = exports.uniformRandFunctions.pickRandom
        