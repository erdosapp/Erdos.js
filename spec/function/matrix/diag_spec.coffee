assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "diag", ->
  it "should return a diagonal matrix on the default diagonal", ->
    assert.deepEqual erdos.diag([1, 2, 3]).valueOf(), [[1, 0, 0], [0, 2, 0], [0, 0, 3]]
    assert.deepEqual erdos.diag([[1, 2, 3], [4, 5, 6]]).valueOf(), [1, 5]

  it "should return a diagonal matrix on the given diagonal", ->
    assert.deepEqual erdos.diag([1, 2, 3], 1).valueOf(), [[0, 1, 0, 0], [0, 0, 2, 0], [0, 0, 0, 3]]
    assert.deepEqual erdos.diag([1, 2, 3], -1).valueOf(), [[0, 0, 0], [1, 0, 0], [0, 2, 0], [0, 0, 3]]
    assert.deepEqual erdos.diag([[1, 2, 3], [4, 5, 6]], 1).valueOf(), [2, 6]
    assert.deepEqual erdos.diag([[1, 2, 3], [4, 5, 6]], -1).valueOf(), [4]
    assert.deepEqual erdos.diag([[1, 2, 3], [4, 5, 6]], -2).valueOf(), []

  it "should throw an error of the input matrix is not valid", ->
    assert.throws ->
      erdos.diag [[[1], [2]], [[3], [4]]]
