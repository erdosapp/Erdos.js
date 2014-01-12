assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

bignumber = erdos.bignumber
min = erdos.min

describe "min", ->
  it "should return the min between several numbers", ->
    assert.equal min(5), 5
    assert.equal min(1, 3), 1
    assert.equal min(3, 1), 1
    assert.equal min(1, 3, 5, -5, 2), -5
    assert.equal min(0, 0, 0, 0), 0

  it "should return the min string following lexical order", ->
    assert.equal min("A", "C", "D", "B"), "A"

  it "should return the min element from a vector", ->
    assert.equal min([1, 3, 5, -5, 2]), -5

  it "should return the min of big numbers", ->
    assert.deepEqual min(bignumber(1), bignumber(3), bignumber(5), bignumber(2), bignumber(-5)), bignumber(-5)

  it "should return the min element from a vector array", ->
    assert.equal min(erdos.matrix([1, 3, 5, -5, 2])), -5

  it "should return the max element from a 2d matrix", ->
    assert.deepEqual min([[1, 4, 7], [3, 0, 5], [-1, 9, 11]]), -1
    assert.deepEqual min(erdos.matrix([[1, 4, 7], [3, 0, 5], [-1, 9, 11]])), -1

  it "should return a reduced n-1 matrix from a n matrix", ->
    assert.deepEqual min([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 0), [1, 2, 3]
    assert.deepEqual min([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1), [1, 4, 7]
    assert.deepEqual min([[[1, 2], [3, 4], [5, 6]], [[6, 7], [8, 9], [10, 11]]], 2), [[1, 3, 5], [6, 8, 10]]
    assert.deepEqual min([[[1, 2], [3, 4], [5, 6]], [[6, 7], [8, 9], [10, 11]]], 1), [[1, 2], [6, 7]]
    assert.deepEqual min([[[1, 2], [3, 4], [5, 6]], [[6, 7], [8, 9], [10, 11]]], 0), [[1, 2], [3, 4], [5, 6]]

  it "should throw an error when called with complex numbers", ->
    assert.throws (->
      min erdos.complex(2, 3), erdos.complex(2, 1)
    ), TypeError
    assert.throws (->
      min erdos.complex(2, 3), erdos.complex(2, 5)
    ), TypeError
    assert.throws (->
      min erdos.complex(3, 4), 4
    ), TypeError
    assert.throws (->
      min erdos.complex(3, 4), 5
    ), TypeError
    assert.throws (->
      min 5, erdos.complex(3, 4)
    ), TypeError
    assert.throws (->
      min erdos.complex(3, 4), 6
    ), TypeError

  it "should throw an error if called with invalid number of arguments", ->
    assert.throws ->
      min()

  it "should throw an error if called with an empty array", ->
    assert.throws ->
      min []
