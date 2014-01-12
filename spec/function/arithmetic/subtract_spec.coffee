# test subtract
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
subtract = erdos.subtract

describe "subtract", ->
  it "should subtract two numbers correctly", ->
    assert.deepEqual subtract(4, 2), 2
    assert.deepEqual subtract(4, -4), 8
    assert.deepEqual subtract(-4, -4), 0
    assert.deepEqual subtract(-4, 4), -8
    assert.deepEqual subtract(2, 4), -2
    assert.deepEqual subtract(3, 0), 3
    assert.deepEqual subtract(0, 3), -3
    assert.deepEqual subtract(0, 3), -3
    assert.deepEqual subtract(0, 3), -3

  it "should subtract booleans", ->
    assert.equal subtract(true, true), 0
    assert.equal subtract(true, false), 1
    assert.equal subtract(false, true), -1
    assert.equal subtract(false, false), 0

  it "should subtract mixed numbers and booleans", ->
    assert.equal subtract(2, true), 1
    assert.equal subtract(2, false), 2
    assert.equal subtract(true, 2), -1
    assert.equal subtract(false, 2), -2

  it "should subtract bignumbers", ->
    assert.deepEqual subtract(bignumber(0.3), bignumber(0.2)), bignumber(0.1)
    assert.deepEqual subtract(bignumber("2.3e5001"), bignumber("3e5000")), bignumber("2e5001")
    assert.deepEqual subtract(bignumber("1e19"), bignumber("1")), bignumber("9999999999999999999")

  it "should subtract mixed numbers and bignumbers", ->
    assert.deepEqual subtract(bignumber(0.3), 0.2), bignumber(0.1)
    assert.deepEqual subtract(0.3, bignumber(0.2)), bignumber(0.1)
    approx.equal subtract(1 / 3, bignumber(1).div(3)), 0
    approx.equal subtract(bignumber(1).div(3), 1 / 3), 0

  it "should subtract mixed booleans and bignumbers", ->
    assert.deepEqual subtract(bignumber(1.1), true), bignumber(0.1)
    assert.deepEqual subtract(false, bignumber(0.2)), bignumber(-0.2)

  it "should subtract two complex numbers correctly", ->
    assert.equal subtract(erdos.complex(3, 2), erdos.complex(8, 4)), "-5 - 2i"
    assert.equal subtract(erdos.complex(6, 3), erdos.complex(-2, -2)), "8 + 5i"
    assert.equal subtract(erdos.complex(3, 4), 10), "-7 + 4i"
    assert.equal subtract(erdos.complex(3, 4), -2), "5 + 4i"
    assert.equal subtract(erdos.complex(-3, -4), 10), "-13 - 4i"
    assert.equal subtract(10, erdos.complex(3, 4)), "7 - 4i"
    assert.equal subtract(10, erdos.i), "10 - i"
    assert.equal subtract(0, erdos.i), "-i"
    assert.equal subtract(10, erdos.complex(0, 1)), "10 - i"

  it "should subtract mixed complex numbers and big numbers", ->
    assert.equal subtract(erdos.complex(3, 4), erdos.bignumber(10)), "-7 + 4i"
    assert.equal subtract(erdos.bignumber(10), erdos.complex(3, 4)), "7 - 4i"

  it "should subtract two quantities of the same unit", ->
    approx.deepEqual subtract(erdos.unit(5, "km"), erdos.unit(100, "mile")), erdos.unit(-155.93, "km")

  it "should throw an error if subtracting two quantities of different units", ->
    assert.throws ->
      subtract erdos.unit(5, "km"), erdos.unit(100, "gram")

  it "should throw an error if subtracting numbers from units", ->
    assert.throws (->
      subtract erdos.unit(5, "km"), 2
    ), erdos.error.UnsupportedTypeError
    
    assert.throws (->
      subtract 2, erdos.unit(5, "km")
    ), erdos.error.UnsupportedTypeError

  it "should throw an error if subtracting numbers from units", ->
    assert.throws (->
      subtract erdos.unit(5, "km"), bignumber(2)
    ), erdos.error.UnsupportedTypeError

    assert.throws (->
      subtract bignumber(2), erdos.unit(5, "km")
    ), erdos.error.UnsupportedTypeError

  it "should throw an error when used with a string", ->
    assert.throws ->
      subtract "hello ", "world"

    assert.throws ->
      subtract "str", 123

    assert.throws ->
      subtract 123, "str"

  it "should perform element-wise subtraction of two matrices", ->
    a2 = erdos.matrix([[1, 2], [3, 4]])
    a3 = erdos.matrix([[5, 6], [7, 8]])
    a6 = subtract(a2, a3)
    assert.ok a6 instanceof erdos.Matrix
    assert.deepEqual a6.size(), [2, 2]
    assert.deepEqual a6.valueOf(), [[-4, -4], [-4, -4]]
