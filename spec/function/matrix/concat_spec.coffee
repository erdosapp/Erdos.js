assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

bignumber = erdos.bignumber

describe "concat", ->
  a = [[1, 2], [3, 4]]
  b = [[5, 6], [7, 8]]
  c = [[9, 10], [11, 12]]
  d = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
  e = [[[9, 10], [11, 12]], [[13, 14], [15, 16]]]

  it "should concatenate compatible matrices on the last dimension by default", ->
    assert.deepEqual erdos.concat([1, 2, 3], [4]), [1, 2, 3, 4]
    assert.deepEqual erdos.concat([bignumber(1), bignumber(2), bignumber(3)], [bignumber(4)]), [bignumber(1), bignumber(2), bignumber(3), bignumber(4)]
    assert.deepEqual erdos.concat([[1], [2], [3]], [[4]], 0), [[1], [2], [3], [4]]
    assert.deepEqual erdos.concat([[], []], [[1, 2], [3, 4]]), [[1, 2], [3, 4]]
    assert.deepEqual erdos.concat(erdos.matrix(a), erdos.matrix(b)), erdos.matrix([[1, 2, 5, 6], [3, 4, 7, 8]])
    assert.deepEqual erdos.concat(a, b, c), [[1, 2, 5, 6, 9, 10], [3, 4, 7, 8, 11, 12]]
    assert.deepEqual erdos.concat(d, e), [[[1, 2, 9, 10], [3, 4, 11, 12]], [[5, 6, 13, 14], [7, 8, 15, 16]]]

  it "should concatenate compatible matrices on the given dimension", ->
    assert.deepEqual erdos.concat([[1]], [[2]], 1), [[1, 2]]
    assert.deepEqual erdos.concat([[1]], [[2]], 0), [[1], [2]]
    assert.deepEqual erdos.concat([[1]], [[2]], 0), [[1], [2]]
    assert.deepEqual erdos.concat(a, b, 0), [[1, 2], [3, 4], [5, 6], [7, 8]]
    assert.deepEqual erdos.concat(a, b, c, 0), [[1, 2], [3, 4], [5, 6], [7, 8], [9, 10], [11, 12]]
    assert.deepEqual erdos.concat(d, e, 0), [[[1, 2], [3, 4]], [[5, 6], [7, 8]], [[9, 10], [11, 12]], [[13, 14], [15, 16]]]
    assert.deepEqual erdos.concat(d, e, 1), [[[1, 2], [3, 4], [9, 10], [11, 12]], [[5, 6], [7, 8], [13, 14], [15, 16]]]
