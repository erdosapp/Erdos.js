assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
cot = erdos.cot

describe "cot", ->
  it "should return the cotan of a boolean", ->
    approx.equal cot(true), 0.642092615934331
    approx.equal cot(false), Infinity

  it "should return the cotan of a number", ->
    approx.equal cot(0), Infinity
    approx.equal 1 / cot(pi * 1 / 4), 1
    approx.equal 1 / cot(pi * 1 / 8), 0.414213562373095
    approx.equal cot(pi * 2 / 4), 0
    approx.equal 1 / cot(pi * 3 / 4), -1
    approx.equal 1 / cot(pi * 4 / 4), 0
    approx.equal 1 / cot(pi * 5 / 4), 1
    approx.equal cot(pi * 6 / 4), 0
    approx.equal 1 / cot(pi * 7 / 4), -1
    approx.equal 1 / cot(pi * 8 / 4), 0

  it "should return the cotan of a bignumber (downgrades to number)", ->
    approx.equal cot(erdos.bignumber(1)), 0.642092615934331

  it "should return the cotan of a complex number", ->
    re = 0.00373971037633696
    im = 0.99675779656935837
    approx.deepEqual cot(complex("2+3i")), complex(-re, -im)
    approx.deepEqual cot(complex("2-3i")), complex(-re, im)
    approx.deepEqual cot(complex("-2+3i")), complex(re, -im)
    approx.deepEqual cot(complex("-2-3i")), complex(re, im)
    approx.deepEqual cot(complex("i")), complex(0, -1.313035285499331)
    approx.deepEqual cot(complex("1")), complex(0.642092615934331, 0)
    approx.deepEqual cot(complex("1+i")), complex(0.217621561854403, -0.868014142895925)

  it "should return the cotan of an angle", ->
    approx.equal cot(unit("45deg")), 1
    approx.equal cot(unit("-45deg")), -1

  it "should throw an error if called with an invalid unit", ->
    assert.throws ->
      cot unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      cot "string"

  cot123 = [0.642092615934331, -0.457657554360286, -7.015252551434534]
  it "should return the cotan of each element of an array", ->
    approx.deepEqual cot([1, 2, 3]), cot123

  it "should return the cotan of each element of a matrix", ->
    approx.deepEqual cot(matrix([1, 2, 3])), matrix(cot123)
