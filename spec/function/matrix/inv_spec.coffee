# test inv
assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "inv", ->
  it "should return the inverse of a number", ->
    assert.deepEqual erdos.inv(4), 1 / 4
    assert.deepEqual erdos.inv(erdos.bignumber(4)), erdos.bignumber(1 / 4)

  it "should return the inverse for each element in an array", ->
    assert.deepEqual erdos.inv([4]), [1 / 4]
    assert.deepEqual erdos.inv([[4]]), [[1 / 4]]
    approx.deepEqual erdos.inv([[1, 4, 7], [3, 0, 5], [-1, 9, 11]]), [[5.625, -2.375, -2.5], [4.75, -2.25, -2], [-3.375, 1.625, 1.5]]
    approx.deepEqual erdos.inv([[2, -1, 0], [-1, 2, -1], [0, -1, 2]]), [[3 / 4, 1 / 2, 1 / 4], [1 / 2, 1, 1 / 2], [1 / 4, 1 / 2, 3 / 4]]

  it "should return the inverse for each element in a matrix", ->
    assert.deepEqual erdos.inv(erdos.matrix([4])), erdos.matrix([1 / 4])
    assert.deepEqual erdos.inv(erdos.matrix([[4]])), erdos.matrix([[1 / 4]])
    assert.deepEqual erdos.inv(erdos.matrix([[1, 2], [3, 4]])), erdos.matrix([[-2, 1], [1.5, -0.5]])
  