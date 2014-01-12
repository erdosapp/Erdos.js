# test zeros
assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

zeros = erdos.zeros
matrix = erdos.matrix

describe "zeros", ->
  it "should create an empty matrix", ->
    assert.deepEqual zeros(), matrix()
    assert.deepEqual zeros([]), []
    assert.deepEqual zeros(matrix([])), matrix()

  it "should create a vector with zeros", ->
    assert.deepEqual zeros(3), matrix([0, 0, 0])
    assert.deepEqual zeros(matrix([4])), matrix([0, 0, 0, 0])
    assert.deepEqual zeros([4]), [0, 0, 0, 0]
    assert.deepEqual zeros(0), matrix([])

  it "should create a matrix with bignumber zeros", ->
    zero = erdos.bignumber(0)
    three = erdos.bignumber(3)
    assert.deepEqual zeros(three), matrix([zero, zero, zero])
    assert.deepEqual zeros([three]), [zero, zero, zero]

  it "should create a 2D matrix with zeros from an array", ->
    assert.deepEqual zeros(2, 3), matrix([[0, 0, 0], [0, 0, 0]])
    assert.deepEqual zeros(3, 2), matrix([[0, 0], [0, 0], [0, 0]])
    assert.deepEqual zeros([3, 2]), [[0, 0], [0, 0], [0, 0]]

  it "should create a matrix with zeros from a matrix", ->
    assert.deepEqual zeros(matrix([3])), matrix([0, 0, 0])
    assert.deepEqual zeros(matrix([3, 2])), matrix([[0, 0], [0, 0], [0, 0]])

  it "should create a 3D matrix with zeros", ->
    res = [[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]], [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]]
    assert.deepEqual zeros(2, 3, 4), matrix(res)
    assert.deepEqual zeros(matrix([2, 3, 4])), matrix(res)
    assert.deepEqual zeros([2, 3, 4]), res

  # TODO: test setting `matrix`
  it "should create a matrix with zeros with the same size as original matrix", ->
    a = matrix([[1, 2, 3], [4, 5, 6]])
    assert.deepEqual zeros(erdos.size(a)).size(), a.size()

# TODO: test with invalid input
