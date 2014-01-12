# test transpose
assert   = require("assert")
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "transpose", ->
  it "should transpose a scalar", ->
    assert.deepEqual erdos.transpose(3), 3

  it "should transpose a vector", ->
    assert.deepEqual erdos.transpose([1, 2, 3]), [1, 2, 3]
    assert.deepEqual erdos.transpose(erdos.matrix([1, 2, 3])), erdos.matrix([1, 2, 3])

  it "should transpose a 2d matrix", ->
    assert.deepEqual erdos.transpose([[1, 2, 3], [4, 5, 6]]), [[1, 4], [2, 5], [3, 6]]
    assert.deepEqual erdos.transpose(erdos.matrix([[1, 2, 3], [4, 5, 6]])), erdos.matrix([[1, 4], [2, 5], [3, 6]])
    assert.deepEqual erdos.transpose([[1, 2], [3, 4]]), [[1, 3], [2, 4]]
    assert.deepEqual erdos.transpose([[1, 2, 3, 4]]), [[1], [2], [3], [4]]

  it "should throw an error for invalid matrix transpose", ->
    assert.throws ->
      assert.deepEqual erdos.transpose([[]]), [[]] # size [2,0]

    assert.throws ->
      erdos.transpose [[[1], [2]], [[3], [4]]] # size [2,2,1]
  