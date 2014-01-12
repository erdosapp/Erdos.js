# test squeeze
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

squeeze = erdos.squeeze
size = erdos.size
matrix = erdos.matrix

describe "squeeze", ->
  it "should squeeze the given matrix", ->
    m = erdos.ones(matrix([1, 3, 2]))
    assert.deepEqual size(m), matrix([1, 3, 2])
    assert.deepEqual size(m.valueOf()), [1, 3, 2]
    assert.deepEqual size(squeeze(m)), matrix([3, 2])
    m = erdos.ones(matrix([1, 1, 3]))
    assert.deepEqual size(m), matrix([1, 1, 3])
    assert.deepEqual size(squeeze(m)), matrix([3])
    assert.deepEqual size(squeeze(erdos.range(1, 6))), matrix([5])
    assert.deepEqual squeeze(2.3), 2.3
    assert.deepEqual squeeze(matrix([[5]])), 5
