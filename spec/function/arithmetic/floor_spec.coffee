# test floor
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex   = erdos.complex
matrix    = erdos.matrix
unit      = erdos.unit
range     = erdos.range
floor     = erdos.floor

describe "floor", ->
  it "should round booleans correctly", ->
    assert.equal floor(true), 1
    assert.equal floor(false), 0

  it "should floor numbers correctly", ->
    approx.equal floor(0), 0
    approx.equal floor(1), 1
    approx.equal floor(1.3), 1
    approx.equal floor(1.8), 1
    approx.equal floor(2), 2
    approx.equal floor(-1), -1
    approx.equal floor(-1.3), -2
    approx.equal floor(-1.8), -2
    approx.equal floor(-2), -2
    approx.equal floor(-2.1), -3
    approx.deepEqual floor(erdos.pi), 3

  it "should floor big numbers correctly", ->
    approx.deepEqual floor(bignumber(0)), bignumber(0)
    approx.deepEqual floor(bignumber(1)), bignumber(1)
    approx.deepEqual floor(bignumber(1.3)), bignumber(1)
    approx.deepEqual floor(bignumber(1.8)), bignumber(1)
    approx.deepEqual floor(bignumber(2)), bignumber(2)
    approx.deepEqual floor(bignumber(-1)), bignumber(-1)
    approx.deepEqual floor(bignumber(-1.3)), bignumber(-2)
    approx.deepEqual floor(bignumber(-1.8)), bignumber(-2)
    approx.deepEqual floor(bignumber(-2)), bignumber(-2)
    approx.deepEqual floor(bignumber(-2.1)), bignumber(-3)

  it "should floor complex numbers correctly", ->
    approx.deepEqual floor(complex(0, 0)), complex(0, 0)
    approx.deepEqual floor(complex(1.3, 1.8)), complex(1, 1)
    approx.deepEqual floor(erdos.i), complex(0, 1)
    approx.deepEqual floor(complex(-1.3, -1.8)), complex(-2, -2)

  it "should throw an error with a unit", ->
    assert.throws (->
      floor unit("5cm")
    ), erdos.error.UnsupportedTypeError, "Function floor(unit) not supported"

  it "should throw an error with a string", ->
    assert.throws (->
      floor "hello world"
    ), erdos.error.UnsupportedTypeError, "Function floor(string) not supported"

  it "should floor all elements in a matrix", ->
    approx.deepEqual floor([1.2, 3.4, 5.6, 7.8, 10.0]), [1, 3, 5, 7, 10]
    approx.deepEqual floor(matrix([1.2, 3.4, 5.6, 7.8, 10.0])), matrix([1, 3, 5, 7, 10])
