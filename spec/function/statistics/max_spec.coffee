assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

bignumber = erdos.bignumber
max = erdos.max

describe "max", ->
  it "should return the max of numbers", ->
    assert.equal max(5), 5
    assert.equal max(3, 1), 3
    assert.equal max(1, 3), 3
    assert.equal max(1, 3, 5, 2, -5), 5
    assert.equal max(0, 0, 0, 0), 0

  it "should return the max of big numbers", ->
    assert.deepEqual max(bignumber(1), bignumber(3), bignumber(5), bignumber(2), bignumber(-5)), bignumber(5)

  it "should return the max string following lexical order", ->
    assert.equal max("A", "C", "D", "B"), "D"

  it "should return the max element from a vector", ->
    assert.equal max(erdos.matrix([1, 3, 5, 2, -5])), 5

  it "should return the max element from a 2d matrix", ->
    assert.deepEqual max([[1, 4, 7], [3, 0, 5], [-1, 11, 9]]), 11
    assert.deepEqual max(erdos.matrix([[1, 4, 7], [3, 0, 5], [-1, 11, 9]])), 11

  it "should return a reduced n-1 matrix from a n matrix", ->
    assert.deepEqual max([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 0), [7, 8, 9]
    assert.deepEqual max([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 1), [3, 6, 9]
    assert.deepEqual max([[[1, 2], [3, 4], [5, 6]], [[6, 7], [8, 9], [10, 11]]], 2), [[2, 4, 6], [7, 9, 11]]

  it "should throw an error when called with complex numbers", ->
    assert.throws (->
      max erdos.complex(2, 3), erdos.complex(2, 1)
    ), TypeError
    assert.throws (->
      max erdos.complex(2, 3), erdos.complex(2, 5)
    ), TypeError
    assert.throws (->
      max erdos.complex(3, 4), 4
    ), TypeError
    assert.throws (->
      max erdos.complex(3, 4), 5
    ), TypeError
    assert.throws (->
      max 5, erdos.complex(3, 4)
    ), TypeError
    assert.throws (->
      max erdos.complex(3, 4), 6
    ), TypeError

  it "should throw an error if called with invalid number of arguments", ->
    assert.throws ->
      max()

  it "should return undefined if called with an empty array", ->
    assert.throws ->
      max []
