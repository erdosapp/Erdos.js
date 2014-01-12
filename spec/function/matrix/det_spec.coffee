assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "det", ->
  it "should calculate correctly the determinant of a number", ->
    assert.equal erdos.det(3), 3

  it "should calculate correctly the determinant of a bignumber", ->
    assert.deepEqual erdos.det(erdos.bignumber(3)), erdos.bignumber(3)

  it "should calculate correctly the determinant of a 2x2 matrix", ->
    assert.equal erdos.det([5]), 5
    assert.equal erdos.det([[1, 2], [3, 4]]), -2
    assert.equal erdos.det(erdos.matrix([[1, 2], [3, 4]])), -2
    assert.equal erdos.det([[-2, 2, 3], [-1, 1, 3], [2, 0, -1]]), 6
    assert.equal erdos.det([[1, 4, 7], [3, 0, 5], [-1, 9, 11]]), -8
    assert.equal erdos.det(erdos.diag([4, -5, 6])), -120
