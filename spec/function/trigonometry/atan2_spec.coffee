# test atan2
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
acos = erdos.acos
atan = erdos.atan
asin = erdos.asin
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
divide = erdos.divide
round = erdos.round
sec = erdos.sec
csc = erdos.csc
cot = erdos.cot
sin = erdos.sin
cos = erdos.cos
tan = erdos.tan
atan2 = erdos.atan2

describe "atan2", ->
  it "should calculate atan2 correctly", ->
    approx.equal atan2(0, 0) / pi, 0
    approx.equal atan2(0, 1) / pi, 0
    approx.equal atan2(1, 1) / pi, 0.25
    approx.equal atan2(1, 0) / pi, 0.5
    approx.equal atan2(1, -1) / pi, 0.75
    approx.equal atan2(0, -1) / pi, 1
    approx.equal atan2(-1, -1) / pi, -0.75
    approx.equal atan2(-1, 0) / pi, -0.5
    approx.equal atan2(-1, 1) / pi, -0.25

  it "should calculate atan2 for booleans", ->
    assert.equal atan2(true, true), 0.25 * pi
    assert.equal atan2(true, false), 0.5 * pi
    assert.equal atan2(false, true), 0
    assert.equal atan2(false, false), 0

  it "should calculate atan2 with mixed numbers and booleans", ->
    assert.equal atan2(1, true), 0.25 * pi
    assert.equal atan2(1, false), 0.5 * pi
    assert.equal atan2(true, 1), 0.25 * pi
    assert.equal atan2(false, 1), 0

  it "should return the arctan of for bignumbers (downgrades to number)", ->
    approx.equal atan2(erdos.bignumber(1), erdos.bignumber(1)), pi / 4

  it "should return the arctan of for mixed numbers and bignumbers (downgrades to number)", ->
    approx.equal atan2(1, erdos.bignumber(1)), pi / 4
    approx.equal atan2(erdos.bignumber(1), 1), pi / 4

  it "should throw an error if called with a complex", ->
    assert.throws ->
      atan2 complex("2+3i"), complex("1-2i")

  it "should throw an error if called with a string", ->
    assert.throws ->
      atan2 "string", 1

  it "should throw an error if called with a unit", ->
    assert.throws ->
      atan2 unit("5cm"), 1

  it "should calculate the atan2 element-wise for arrays and matrices", ->  
    # array, matrix, range
    approx.deepEqual divide(atan2([1, 0, -1], [1, 0, -1]), pi), [0.25, 0, -0.75]
    approx.deepEqual divide(atan2(matrix([1, 0, -1]), matrix([1, 0, -1])), pi), matrix([0.25, 0, -0.75])
    approx.equal atan2(0, 2) / pi, 0
    approx.equal atan2(0, -2) / pi, 1
