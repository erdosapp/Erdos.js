# test ceil
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex   = erdos.complex
matrix    = erdos.matrix
unit      = erdos.unit
range     = erdos.range
ceil      = erdos.ceil
UnsupportedTypeError = erdos.error.UnsupportedTypeError

describe "ceil", ->
  it "should return the ceil value of a boolean", ->
    assert.equal ceil(true), 1
    assert.equal ceil(false), 0
 
  it "should return the ceil of a number", ->
    approx.equal ceil(0), 0
    approx.equal ceil(1), 1
    approx.equal ceil(1.3), 2
    approx.equal ceil(1.8), 2
    approx.equal ceil(2), 2
    approx.equal ceil(-1), -1
    approx.equal ceil(-1.3), -1
    approx.equal ceil(-1.8), -1
    approx.equal ceil(-2), -2
    approx.equal ceil(-2.1), -2
    approx.deepEqual ceil(erdos.pi), 4
 
  it "should return the ceil of a big number", ->
    approx.deepEqual ceil(bignumber(0)), bignumber(0)
    approx.deepEqual ceil(bignumber(1)), bignumber(1)
    approx.deepEqual ceil(bignumber(1.3)), bignumber(2)
    approx.deepEqual ceil(bignumber(1.8)), bignumber(2)
    approx.deepEqual ceil(bignumber(2)), bignumber(2)
    approx.deepEqual ceil(bignumber(-1)), bignumber(-1)
    approx.deepEqual ceil(bignumber(-1.3)), bignumber(-1)
    approx.deepEqual ceil(bignumber(-1.8)), bignumber(-1)
    approx.deepEqual ceil(bignumber(-2)), bignumber(-2)
    approx.deepEqual ceil(bignumber(-2.1)), bignumber(-2)
 
  it "should return the ceil of real and imag part of a complex", ->
    approx.deepEqual ceil(complex(0, 0)), complex(0, 0)
    approx.deepEqual ceil(complex(1.3, 1.8)), complex(2, 2)
    approx.deepEqual ceil(erdos.i), complex(0, 1)
    approx.deepEqual ceil(complex(-1.3, -1.8)), complex(-1, -1)

  it "should throw an error for units", ->
    assert.throws (->
      ceil unit("5cm")
    ), UnsupportedTypeError, "Function ceil(unit) not supported"

  it "should throw an error for strings", ->
    assert.throws (->
      ceil "hello world"
    ), UnsupportedTypeError, "Function ceil(string) not supported"

  it "should ceil each element in a matrix, array or range", ->
    approx.deepEqual ceil([1.2, 3.4, 5.6, 7.8, 10.0]), [2, 4, 6, 8, 10]
    approx.deepEqual ceil(matrix([1.2, 3.4, 5.6, 7.8, 10.0])), matrix([2, 4, 6, 8, 10])
  