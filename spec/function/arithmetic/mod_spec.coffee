# test mod
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
matrix = erdos.matrix
range = erdos.range
mod = erdos.mod

describe "mod", ->
  it "should calculate the modulus of booleans correctly", ->
    assert.equal mod(true, true), 0
    assert.equal mod(false, true), 0
    assert.equal mod(true, false), 1
    assert.equal mod(false, false), 0

  it "should calculate the modulus of two numbers", ->
    assert.equal mod(1, 1), 0
    assert.equal mod(0, 1), 0
    assert.equal mod(1, 0), 1
    assert.equal mod(0, 0), 0
    approx.equal mod(7, 2), 1
    approx.equal mod(9, 3), 0
    approx.equal mod(10, 4), 2
    approx.equal mod(-10, 4), 2
    approx.equal mod(8.2, 3), 2.2
    approx.equal mod(4, 1.5), 1
    approx.equal mod(0, 3), 0

  it "should throw an error if the modulus is negative", ->
    assert.throws ->
      mod 10, -4

  it "should throw an error if used with wrong number of arguments", ->
    assert.throws (->
      mod 1
    ), SyntaxError
    assert.throws (->
      mod 1, 2, 3
    ), SyntaxError

  it "should calculate the modulus of bignumbers", ->
    assert.deepEqual mod(bignumber(7), bignumber(2)), bignumber(1)
    assert.deepEqual mod(bignumber(7), bignumber(2)), bignumber(1)
    assert.deepEqual mod(bignumber(8), bignumber(3)).valueOf(), bignumber(2).valueOf()

  it.skip "should calculate the modulus of bignumbers for fractions", ->
    assert.deepEqual mod(bignumber(7).div(3), bignumber(1).div(3)), bignumber(0)

  it.skip "should calculate the modulus of bignumbers for negative values", ->
    assert.deepEqual mod(bignumber(-10), bignumber(4)), bignumber(2)

  it "should calculate the modulus of mixed numbers and bignumbers", ->
    assert.deepEqual mod(bignumber(7), 2), bignumber(1)
    assert.deepEqual mod(8, bignumber(3)), bignumber(2)
    approx.equal mod(7 / 3, bignumber(2)), 1 / 3
    approx.equal mod(7 / 3, 1 / 3), 0
    approx.equal mod(bignumber(7).div(3), 1 / 3), 0

  it "should calculate the modulus of mixed booleans and bignumbers", ->
    assert.deepEqual mod(bignumber(7), true), bignumber(0)
    assert.deepEqual mod(true, bignumber(3)), bignumber(1)

  it "should throw an error if used on complex numbers", ->
    assert.throws (->
      mod erdos.complex(1, 2), 3
    ), erdos.error.UnsupportedTypeError

    assert.throws (->
      mod 3, erdos.complex(1, 2)
    ), erdos.error.UnsupportedTypeError

    assert.throws (->
      mod bignumber(3), erdos.complex(1, 2)
    ), erdos.error.UnsupportedTypeError

  it "should an throw an error if used on a string", ->
    assert.throws (->
      mod "string", 3
    ), erdos.error.UnsupportedTypeError
    
    assert.throws (->
      mod 5, "string"
    ), erdos.error.UnsupportedTypeError

  it "should perform element-wise modulus on a matrix", ->
    approx.deepEqual mod([-4, -3, -2, -1, 0, 1, 2, 3, 4], 3), [2, 0, 1, 2, 0, 1, 2, 0, 1]
    approx.deepEqual mod(matrix([-4, -3, -2, -1, 0, 1, 2, 3, 4]), 3), matrix([2, 0, 1, 2, 0, 1, 2, 0, 1])
