# test smaller
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
smaller = erdos.smaller

describe "smaller", ->
  it "should compare two numbers correctly", ->
    assert.equal smaller(2, 3), true
    assert.equal smaller(2, 2), false
    assert.equal smaller(2, 1), false
    assert.equal smaller(0, 0), false
    assert.equal smaller(-2, 2), true
    assert.equal smaller(-2, -3), false
    assert.equal smaller(-3, -2), true

  it "should compare two booleans", ->
    assert.equal smaller(true, true), false
    assert.equal smaller(true, false), false
    assert.equal smaller(false, true), true
    assert.equal smaller(false, false), false

  it "should compare mixed numbers and booleans", ->
    assert.equal smaller(2, true), false
    assert.equal smaller(1, true), false
    assert.equal smaller(0, true), true
    assert.equal smaller(true, 2), true
    assert.equal smaller(true, 1), false
    assert.equal smaller(false, 2), true

  it "should compare bignumbers", ->
    assert.deepEqual smaller(bignumber(2), bignumber(3)), true
    assert.deepEqual smaller(bignumber(2), bignumber(2)), false
    assert.deepEqual smaller(bignumber(3), bignumber(2)), false
    assert.deepEqual smaller(bignumber(0), bignumber(0)), false
    assert.deepEqual smaller(bignumber(-2), bignumber(2)), true

  it "should compare mixed numbers and bignumbers", ->
    assert.deepEqual smaller(bignumber(2), 3), true
    assert.deepEqual smaller(2, bignumber(2)), false
    assert.equal smaller(1 / 3, bignumber(1).div(3)), false
    assert.equal smaller(bignumber(1).div(3), 1 / 3), false

  it "should compare mixed booleans and bignumbers", ->
    assert.deepEqual smaller(bignumber(0.1), true), true
    assert.deepEqual smaller(bignumber(1), true), false
    assert.deepEqual smaller(false, bignumber(0)), false

  it "should compare two measures of the same unit correctly", ->
    assert.equal smaller(unit("100cm"), unit("10inch")), false
    assert.equal smaller(unit("99cm"), unit("1m")), true
    
    #assert.equal(smaller(unit('100cm'), unit('1m')), false); // dangerous, round-off errors
    assert.equal smaller(unit("101cm"), unit("1m")), false

  it "should throw an error if comparing a unit and a number", ->
    assert.throws ->
      smaller unit("100cm"), 22

  it "should throw an error if comparing a unit and a bignumber", ->
    assert.throws ->
      smaller unit("100cm"), bignumber(22)

  it "should perform lexical comparison on two strings", ->
    assert.equal smaller("0", 0), false
    assert.equal smaller("abd", "abc"), false
    assert.equal smaller("abc", "abc"), false
    assert.equal smaller("abc", "abd"), true

  it "should perform element-wise comparison on two matrices of same size", ->
    assert.deepEqual smaller([1, 4, 6], [3, 4, 5]), [true, false, false]
    assert.deepEqual smaller([1, 4, 6], matrix([3, 4, 5])), matrix([true, false, false])

  it "should throw an error when comparing complex numbers", ->
    assert.throws (->
      smaller complex(1, 1), complex(1, 2)
    ), TypeError
    assert.throws (->
      smaller complex(2, 1), 3
    ), TypeError
    assert.throws (->
      smaller 3, complex(2, 4)
    ), TypeError
    assert.throws (->
      smaller erdos.bignumber(3), complex(2, 4)
    ), TypeError
    assert.throws (->
      smaller complex(2, 4), erdos.bignumber(3)
    ), TypeError

  it "should throw an error with two matrices of different sizes", ->
    assert.throws ->
      smaller [1, 4, 6], [3, 4]
