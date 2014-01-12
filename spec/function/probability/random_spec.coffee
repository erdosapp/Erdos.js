assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

seed = require("seed-random")
_ = require("underscore")

assertApproxEqual = (testVal, val, tolerance) ->
  diff = Math.abs(val - testVal)
  if diff > tolerance
    assert.equal testVal, val
  else
    assert.ok diff <= tolerance

assertUniformDistribution = (values, min, max) ->
  interval = (max - min) / 10
  count = undefined
  i = undefined
  count = _.filter(values, (val) ->
    val < min
  ).length
  assert.equal count, 0
  count = _.filter(values, (val) ->
    val > max
  ).length
  assert.equal count, 0
  i = 0
  while i < 10
    count = _.filter(values, (val) ->
      val >= (min + i * interval) and val < (min + (i + 1) * interval)
    ).length
    assertApproxEqual count / values.length, 0.1, 0.02
    i++

assertUniformDistributionInt = (values, min, max) ->
  range = _.range(Math.floor(min), Math.floor(max))
  count = undefined
  values.forEach (val) ->
    assert.ok _.contains(range, val)

  range.forEach (val) ->
    count = _.filter(values, (testVal) ->
      testVal is val
    ).length
    assertApproxEqual count / values.length, 1 / range.length, 0.03

describe "distribution", ->
  originalRandom = undefined
  uniformDistrib = undefined
  before ->
    
    # replace the original Math.random with a reproducible one
    originalRandom = Math.random
    Math.random = seed("key")

  after ->
    
    # restore the original random function
    Math.random = originalRandom

  beforeEach ->
    uniformDistrib = erdos.distribution("uniform")

  describe "random", ->
    originalRandom = undefined
    it "should pick uniformely distributed numbers in [0, 1]", ->
      picked = []
      _.times 1000, ->
        picked.push uniformDistrib.random()

      assertUniformDistribution picked, 0, 1

    it "should pick uniformely distributed numbers in [min, max]", ->
      picked = []
      _.times 1000, ->
        picked.push uniformDistrib.random(-10, 10)

      assertUniformDistribution picked, -10, 10

    it "should pick uniformely distributed random matrix, with elements in [0, 1]", ->
      picked = []
      matrices = []
      size = [2, 3, 4]
      _.times 100, ->
        matrices.push uniformDistrib.random(size)

      # Collect all values in one array
      matrices.forEach (matrix) ->
        assert.deepEqual matrix.size(), size
        matrix.forEach (val) ->
          picked.push val

      assert.equal picked.length, 2 * 3 * 4 * 100
      assertUniformDistribution picked, 0, 1

    it "should pick uniformely distributed random matrix, with elements in [min, max]", ->
      picked = []
      matrices = []
      size = [2, 3, 4]
      _.times 100, ->
        matrices.push uniformDistrib.random(size, -103, 8)

      # Collect all values in one array
      matrices.forEach (matrix) ->
        assert.deepEqual matrix.size(), size
        matrix.forEach (val) ->
          picked.push val

      assert.equal picked.length, 2 * 3 * 4 * 100
      assertUniformDistribution picked, -103, 8

    it.skip "should throw an error if called with invalid arguments", ->
      assert.throws ->
        uniformDistrib.random "str", 10

  describe "randomInt", ->
    it "should pick uniformely distributed integers in [min, max)", ->
      picked = []
      _.times 10000, ->
        picked.push uniformDistrib.randomInt(-15, -5)

      assertUniformDistributionInt picked, -15, -5

    it "should pick uniformely distributed random matrix, with elements in [min, max)", ->
      picked = []
      matrices = []
      size = [2, 3, 4]
      _.times 1000, ->
        matrices.push uniformDistrib.randomInt(size, -14.9, -2)
      
      # Collect all values in one array
      matrices.forEach (matrix) ->
        assert.deepEqual matrix.size(), size
        matrix.forEach (val) ->
          picked.push val

      assert.equal picked.length, 2 * 3 * 4 * 1000
      assertUniformDistributionInt picked, -14.9, -2

    it "should throw an error if called with invalid arguments", ->
      assert.throws ->
        uniformDistrib.randomInt 1, 2, [4, 8]

      assert.throws ->
        uniformDistrib.randomInt 1, 2, 3, 6

  describe "pickRandom", ->
    it "should pick numbers from the given array following an uniform distribution", ->
      possibles = [11, 22, 33, 44, 55]
      picked = []
      count = undefined
      _.times 1000, ->
        picked.push uniformDistrib.pickRandom(possibles)

      count = _.filter(picked, (val) ->
        val is 11
      ).length
      assert.equal erdos.round(count / picked.length, 1), 0.2
      count = _.filter(picked, (val) ->
        val is 22
      ).length
      assert.equal erdos.round(count / picked.length, 1), 0.2
      count = _.filter(picked, (val) ->
        val is 33
      ).length
      assert.equal erdos.round(count / picked.length, 1), 0.2
      count = _.filter(picked, (val) ->
        val is 44
      ).length
      assert.equal erdos.round(count / picked.length, 1), 0.2
      count = _.filter(picked, (val) ->
        val is 55
      ).length
      assert.equal erdos.round(count / picked.length, 1), 0.2

  describe "distribution.normal", ->
    it "should pick numbers in [0, 1] following a normal distribution", ->
      picked = []
      count = undefined
      distribution = erdos.distribution("normal")
      _.times 100000, ->
        picked.push distribution.random()

      count = _.filter(picked, (val) ->
        val < 0
      ).length
      assert.equal count, 0
      count = _.filter(picked, (val) ->
        val > 1
      ).length
      assert.equal count, 0
      count = _.filter(picked, (val) ->
        val < 0.25
      ).length
      assertApproxEqual count / picked.length, 0.07, 0.01
      count = _.filter(picked, (val) ->
        val < 0.4
      ).length
      assertApproxEqual count / picked.length, 0.27, 0.01
      count = _.filter(picked, (val) ->
        val < 0.5
      ).length
      assertApproxEqual count / picked.length, 0.5, 0.01
      count = _.filter(picked, (val) ->
        val < 0.6
      ).length

      assertApproxEqual count / picked.length, 0.73, 0.01
      count = _.filter(picked, (val) ->
        val < 0.75
      ).length

      assertApproxEqual count / picked.length, 0.93, 0.01
