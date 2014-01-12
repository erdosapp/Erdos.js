# test size
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

matrix = erdos.matrix

describe "size", ->
  it "should calculate the size of an array", ->
    assert.deepEqual erdos.size([[1, 2, 3], [4, 5, 6]]), [2, 3]
    assert.deepEqual erdos.size([[[1, 2], [3, 4]], [[5, 6], [7, 8]]]), [2, 2, 2]
    assert.deepEqual erdos.size([1, 2, 3]), [3]
    assert.deepEqual erdos.size([[1], [2], [3]]), [3, 1]
    assert.deepEqual erdos.size([100]), [1]
    assert.deepEqual erdos.size([[100]]), [1, 1]
    assert.deepEqual erdos.size([[[100]]]), [1, 1, 1]
    assert.deepEqual erdos.size([]), [0]
    assert.deepEqual erdos.size([[]]), [1, 0]
    assert.deepEqual erdos.size([[[]]]), [1, 1, 0]
    assert.deepEqual erdos.size([[[], []]]), [1, 2, 0]

  it "should calculate the size of a matrix", ->
    assert.deepEqual erdos.size(matrix()), matrix([0])
    assert.deepEqual erdos.size(matrix([[1, 2, 3], [4, 5, 6]])), matrix([2, 3])
    assert.deepEqual erdos.size(matrix([[], []])), matrix([2, 0])

  it "should calculate the size of a range", ->
    assert.deepEqual erdos.size(erdos.range(2, 6)), matrix([4])

  it "should calculate the size of a scalar", ->
    assert.deepEqual erdos.size(2), matrix([])
    assert.deepEqual erdos.size(erdos.bignumber(2)), matrix([])
    assert.deepEqual erdos.size(erdos.complex(2, 3)), matrix([])
    assert.deepEqual erdos.size(true), matrix([])
    assert.deepEqual erdos.size(null), matrix([])

  it "should calculate the size of a string", ->
    assert.deepEqual erdos.size("hello"), matrix([5])
    assert.deepEqual erdos.size(""), matrix([0])

# TODO: test whether erdos.size throws an error in case of invalid data or size
