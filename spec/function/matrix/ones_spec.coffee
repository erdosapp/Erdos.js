# test ones
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

ones = erdos.ones
matrix = erdos.matrix

describe "ones", ->
  it "should create an empty matrix", ->
    assert.deepEqual ones(), matrix()
    assert.deepEqual ones([]), []
    assert.deepEqual ones(matrix([])), matrix()

  it "should create a vector with ones", ->
    assert.deepEqual ones(3), matrix([1, 1, 1])
    assert.deepEqual ones(matrix([4])), matrix([1, 1, 1, 1])
    assert.deepEqual ones([4]), [1, 1, 1, 1]
    assert.deepEqual ones(0), matrix([])

  it "should create a 2D matrix with ones", ->
    assert.deepEqual ones(2, 3), matrix([[1, 1, 1], [1, 1, 1]])
    assert.deepEqual ones(3, 2), matrix([[1, 1], [1, 1], [1, 1]])
    assert.deepEqual ones([3, 2]), [[1, 1], [1, 1], [1, 1]]

  it "should create a matrix with ones from a matrix", ->
    assert.deepEqual ones(matrix([3])), matrix([1, 1, 1])
    assert.deepEqual ones(matrix([3, 2])), matrix([[1, 1], [1, 1], [1, 1]])

  it "should create a matrix with bignumber ones", ->
    one = erdos.bignumber(1)
    three = erdos.bignumber(3)
    assert.deepEqual ones(three), matrix([one, one, one])
    assert.deepEqual ones([three]), [one, one, one]

  it "should create a 3D matrix with ones", ->
    res = [[[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]]]
    assert.deepEqual ones(2, 3, 4), matrix(res)
    assert.deepEqual ones(matrix([2, 3, 4])), matrix(res)
    assert.deepEqual ones([2, 3, 4]), res

  # TODO: test setting `matrix`
  it "should create a matrix with ones with the same size as original matrix", ->
    a = matrix([[1, 2, 3], [4, 5, 6]])
    assert.deepEqual ones(erdos.size(a)).size(), a.size()

# TODO: test with invalid input
