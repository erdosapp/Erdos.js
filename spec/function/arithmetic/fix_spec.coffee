# test fix
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
range = erdos.range
fix = erdos.fix

describe "fix", ->
  it "should round booleans correctly", ->
    assert.equal fix(true), 1
    assert.equal fix(false), 0

  it "should round numbers correctly", ->
    approx.equal fix(0), 0
    approx.equal fix(1), 1
    approx.equal fix(1.3), 1
    approx.equal fix(1.8), 1
    approx.equal fix(2), 2
    approx.equal fix(-1), -1
    approx.equal fix(-1.3), -1
    approx.equal fix(-1.8), -1
    approx.equal fix(-2), -2
    approx.equal fix(-2.1), -2
    approx.deepEqual fix(erdos.pi), 3

  it "should round big numbers correctly", ->
    approx.deepEqual fix(bignumber(0)), bignumber(0)
    approx.deepEqual fix(bignumber(1)), bignumber(1)
    approx.deepEqual fix(bignumber(1.3)), bignumber(1)
    approx.deepEqual fix(bignumber(1.8)), bignumber(1)
    approx.deepEqual fix(bignumber(2)), bignumber(2)
    approx.deepEqual fix(bignumber(-1)), bignumber(-1)
    approx.deepEqual fix(bignumber(-1.3)), bignumber(-1)
    approx.deepEqual fix(bignumber(-1.8)), bignumber(-1)
    approx.deepEqual fix(bignumber(-2)), bignumber(-2)
    approx.deepEqual fix(bignumber(-2.1)), bignumber(-2)

  it "should round complex numbers correctly", ->
    # complex
    approx.deepEqual fix(complex(0, 0)), complex(0, 0)
    approx.deepEqual fix(complex(1.3, 1.8)), complex(1, 1)
    approx.deepEqual fix(erdos.i), complex(0, 1)
    approx.deepEqual fix(complex(-1.3, -1.8)), complex(-1, -1)

  it "should throw an error on unit as parameter", ->
    
    # unit
    assert.throws (->
      fix unit("5cm")
    ), erdos.error.UnsupportedTypeError, "Function fix(unit) not supported"

  it "should throw an error on string as parameter", ->
    
    # string
    assert.throws (->
      fix "hello world"
    ), erdos.error.UnsupportedTypeError, "Function fix(string) not supported"

  it "should correctly round all values of a matrix element-wise", ->
    
    # matrix, array, range
    approx.deepEqual fix([1.2, 3.4, 5.6, 7.8, 10.0]), [1, 3, 5, 7, 10]
    approx.deepEqual fix(matrix([1.2, 3.4, 5.6, 7.8, 10.0])), matrix([1, 3, 5, 7, 10])
