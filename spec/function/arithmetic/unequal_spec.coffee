# test equal
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
unequal = erdos.unequal

describe "unequal", ->
  it "should compare two numbers correctly", ->
    assert.equal unequal(2, 3), true
    assert.equal unequal(2, 2), false
    assert.equal unequal(0, 0), false
    assert.equal unequal(-2, 2), true

  it "should compare two booleans", ->
    assert.equal unequal(true, true), false
    assert.equal unequal(true, false), true
    assert.equal unequal(false, true), true
    assert.equal unequal(false, false), false

  it "should compare mixed numbers and booleans", ->
    assert.equal unequal(2, true), true
    assert.equal unequal(1, true), false
    assert.equal unequal(0, true), true
    assert.equal unequal(true, 2), true
    assert.equal unequal(true, 1), false
    assert.equal unequal(false, 2), true
    assert.equal unequal(false, 0), false

  it "should compare bignumbers", ->
    assert.deepEqual unequal(bignumber(2), bignumber(3)), true
    assert.deepEqual unequal(bignumber(2), bignumber(2)), false
    assert.deepEqual unequal(bignumber(3), bignumber(2)), true
    assert.deepEqual unequal(bignumber(0), bignumber(0)), false
    assert.deepEqual unequal(bignumber(-2), bignumber(2)), true

  it "should compare mixed numbers and bignumbers", ->
    assert.deepEqual unequal(bignumber(2), 3), true
    assert.deepEqual unequal(2, bignumber(2)), false
    assert.equal unequal(1 / 3, bignumber(1).div(3)), false
    assert.equal unequal(bignumber(1).div(3), 1 / 3), false

  it "should compare mixed booleans and bignumbers", ->
    assert.deepEqual unequal(bignumber(0.1), true), true
    assert.deepEqual unequal(bignumber(1), true), false
    assert.deepEqual unequal(false, bignumber(0)), false

  it "should compare two complex numbers correctly", ->
    assert.equal unequal(complex(2, 3), complex(2, 4)), true
    assert.equal unequal(complex(2, 3), complex(2, 3)), false
    assert.equal unequal(complex(1, 3), complex(2, 3)), true
    assert.equal unequal(complex(1, 3), complex(2, 4)), true
    assert.equal unequal(complex(2, 0), 2), false
    assert.equal unequal(complex(2, 1), 2), true
    assert.equal unequal(2, complex(2, 0)), false
    assert.equal unequal(2, complex(2, 1)), true
    assert.equal unequal(complex(2, 0), 3), true

  it "should compare mixed complex numbers and bignumbers (downgrades to numbers)", ->
    assert.deepEqual unequal(erdos.complex(6, 0), bignumber(6)), false
    assert.deepEqual unequal(erdos.complex(6, -2), bignumber(6)), true
    assert.deepEqual unequal(bignumber(6), erdos.complex(6, 0)), false
    assert.deepEqual unequal(bignumber(6), erdos.complex(6, 4)), true

  it "should compare two quantitites of the same unit correctly", ->
    assert.equal unequal(unit("100cm"), unit("10inch")), true
    assert.equal unequal(unit("100cm"), unit("1m")), false
  
  #assert.equal(unequal(unit('12inch'), unit('1foot')), false); // round-off error :(
  #assert.equal(unequal(unit('2.54cm'), unit('1inch')), false); // round-off error :(
  it "should throw an error when comparing numbers and units", ->
    assert.throws ->
      unequal unit("100cm"), 22

    assert.throws ->
      unequal 22, unit("100cm")

  it "should throw an error when comparing bignumbers and units", ->
    assert.throws ->
      unequal unit("100cm"), bignumber(22)

    assert.throws ->
      unequal bignumber(22), unit("100cm")

  it "should compare two strings correctly", ->
    assert.equal unequal("0", 0), false
    assert.equal unequal("Hello", "hello"), true
    assert.equal unequal("hello", "hello"), false

  it "should perform element-wise comparison of two matrices of the same size", ->
    assert.deepEqual unequal([1, 4, 5], [3, 4, 5]), [true, false, false]
    assert.deepEqual unequal([1, 4, 5], matrix([3, 4, 5])), matrix([true, false, false])

  it "should throw an error when comparing two matrices of different sizes", ->
    assert.throws ->
      unequal [1, 4, 5], [3, 4]
