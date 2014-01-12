assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

matrix = erdos.matrix
eye = erdos.eye

describe "eye", ->
  it "should create an empty matrix", ->
    assert.deepEqual eye(), matrix()
    assert.deepEqual eye([]), []
    assert.deepEqual eye(matrix([])), matrix()
  
  it "should create an identity matrix of the given size", ->
    assert.deepEqual eye(1), matrix([[1]])
    assert.deepEqual eye(2), matrix([[1, 0], [0, 1]])
    assert.deepEqual eye([2]), [[1, 0], [0, 1]]
    assert.deepEqual eye(2, 3), matrix([[1, 0, 0], [0, 1, 0]])
    assert.deepEqual eye(3, 2), matrix([[1, 0], [0, 1], [0, 0]])
    assert.deepEqual eye([3, 2]), [[1, 0], [0, 1], [0, 0]]
    assert.deepEqual eye(erdos.matrix([3, 2])), matrix([[1, 0], [0, 1], [0, 0]])
    assert.deepEqual eye(3, 3), matrix([[1, 0, 0], [0, 1, 0], [0, 0, 1]])

  it "should create an identity matrix with bignumbers", ->
    zero = erdos.bignumber(0)
    one = erdos.bignumber(1)
    two = erdos.bignumber(2)
    three = erdos.bignumber(3)
    assert.deepEqual eye(two), matrix([[one, zero], [zero, one]])
    assert.deepEqual eye(two, three), matrix([[one, zero, zero], [zero, one, zero]])

  # TODO: test setting `matrix`
  it "should throw an error with an invalid input", ->
    assert.throws ->
      eye 3, 3, 2

    assert.throws ->
      eye [3, 3, 2]
  