# test equal
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
equal = erdos.equal

describe "equal", ->
  it "should compare two numbers correctly", ->
    assert.equal equal(2, 3), false
    assert.equal equal(2, 2), true
    assert.equal equal(0, 0), true
    assert.equal equal(-2, 2), false

  it "should compare two booleans", ->
    assert.equal equal(true, true), true
    assert.equal equal(true, false), false
    assert.equal equal(false, true), false
    assert.equal equal(false, false), true

  it "should compare mixed numbers and booleans", ->
    assert.equal equal(2, true), false
    assert.equal equal(1, true), true
    assert.equal equal(0, true), false
    assert.equal equal(true, 2), false
    assert.equal equal(true, 1), true
    assert.equal equal(false, 2), false
    assert.equal equal(false, 0), true

  it "should compare bignumbers", ->
    assert.equal equal(bignumber(2), bignumber(3)), false
    assert.equal equal(bignumber(2), bignumber(2)), true
    assert.equal equal(bignumber(3), bignumber(2)), false
    assert.equal equal(bignumber(0), bignumber(0)), true
    assert.equal equal(bignumber(-2), bignumber(2)), false

  it "should compare mixed numbers and bignumbers", ->
    assert.deepEqual equal(bignumber(2), 3), false
    assert.deepEqual equal(2, bignumber(2)), true
    assert.equal equal(1 / 3, bignumber(1).div(3)), true
    assert.equal equal(bignumber(1).div(3), 1 / 3), true

  it "should compare mixed booleans and bignumbers", ->
    assert.equal equal(bignumber(0.1), true), false
    assert.equal equal(bignumber(1), true), true
    assert.equal equal(false, bignumber(0)), true

  it "should compare two complex numbers correctly", ->
    assert.equal equal(complex(2, 3), complex(2, 4)), false
    assert.equal equal(complex(2, 3), complex(2, 3)), true
    assert.equal equal(complex(1, 3), complex(2, 3)), false
    assert.equal equal(complex(1, 3), complex(2, 4)), false
    assert.equal equal(complex(2, 0), 2), true
    assert.equal equal(complex(2, 1), 2), false
    assert.equal equal(2, complex(2, 0)), true
    assert.equal equal(2, complex(2, 1)), false
    assert.equal equal(complex(2, 0), 3), false

  it "should compare mixed complex numbers and bignumbers (downgrades to numbers)", ->
    assert.deepEqual equal(erdos.complex(6, 0), bignumber(6)), true
    assert.deepEqual equal(erdos.complex(6, -2), bignumber(6)), false
    assert.deepEqual equal(bignumber(6), erdos.complex(6, 0)), true
    assert.deepEqual equal(bignumber(6), erdos.complex(6, 4)), false

  it "should compare two units correctly", ->
    assert.equal equal(unit("100cm"), unit("10inch")), false
    assert.equal equal(unit("100cm"), unit("1m")), true

  #assert.equal(equal(unit('12inch'), unit('1foot')), true); // round-off error :(
  #assert.equal(equal(unit('2.54cm'), unit('1inch')), true); // round-off error :(
  it "should throw an error when comparing a unit with a big number", ->
    assert.throws ->
      equal(erdos.unit("5 m"), bignumber(10)).toString()

  it "should throw an error when comparing a unit with a number", ->
    assert.throws ->
      equal unit("100cm"), 22

  it "should compare two strings correctly", ->
    assert.equal equal("0", 0), true
    assert.equal equal("Hello", "hello"), false
    assert.equal equal("hello", "hello"), true

  it "should compare two matrices correctly", ->
    assert.deepEqual equal([1, 4, 5], [3, 4, 5]), [false, true, true]
    assert.deepEqual equal([1, 4, 5], matrix([3, 4, 5])), matrix([false, true, true])

  it "should throw an error if matrices have different sizes", ->
    assert.throws ->
      equal [1, 4, 5], [3, 4]
