# test largereq
assert = require("assert")
approx = require("../../../tools/approx")
erdos  = require("../../../lib/erdos")()

bignumber = erdos.bignumber
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
largereq = erdos.largereq

describe "largereq", ->
  it "should compare two numbers correctly", ->
    assert.equal largereq(2, 3), false
    assert.equal largereq(2, 2), true
    assert.equal largereq(2, 1), true
    assert.equal largereq(0, 0), true
    assert.equal largereq(-2, 2), false
    assert.equal largereq(-2, -3), true
    assert.equal largereq(-3, -2), false

  it "should compare two booleans", ->
    assert.equal largereq(true, true), true
    assert.equal largereq(true, false), true
    assert.equal largereq(false, true), false
    assert.equal largereq(false, false), true

  it "should compare mixed numbers and booleans", ->
    assert.equal largereq(2, true), true
    assert.equal largereq(0, true), false
    assert.equal largereq(true, 2), false
    assert.equal largereq(true, 1), true
    assert.equal largereq(false, 0), true

  it "should compare bignumbers", ->
    assert.equal largereq(bignumber(2), bignumber(3)), false
    assert.equal largereq(bignumber(2), bignumber(2)), true
    assert.equal largereq(bignumber(3), bignumber(2)), true
    assert.equal largereq(bignumber(0), bignumber(0)), true
    assert.equal largereq(bignumber(-2), bignumber(2)), false

  it "should compare mixed numbers and bignumbers", ->
    assert.equal largereq(bignumber(2), 3), false
    assert.equal largereq(2, bignumber(2)), true
    assert.equal largereq(1 / 3, bignumber(1).div(3)), true
    assert.equal largereq(bignumber(1).div(3), 1 / 3), true

  it "should compare mixed booleans and bignumbers", ->
    assert.equal largereq(bignumber(0.1), true), false
    assert.equal largereq(bignumber(1), true), true
    assert.equal largereq(false, bignumber(0)), true

  it "should compare two units correctly", ->
    assert.equal largereq(unit("100cm"), unit("10inch")), true
    assert.equal largereq(unit("99cm"), unit("1m")), false
    
    #assert.equal(largereq(unit('100cm'), unit('1m')), true); // dangerous, round-off errors
    assert.equal largereq(unit("101cm"), unit("1m")), true

  it "should throw an error if comparing a unit with a number", ->
    assert.throws ->
      largereq unit("100cm"), 22

  it "should throw an error if comparing a unit with a bignumber", ->
    assert.throws ->
      largereq unit("100cm"), bignumber(22)

  it "should perform lexical comparison for 2 strings", ->
    assert.equal largereq("0", 0), true
    assert.equal largereq("abd", "abc"), true
    assert.equal largereq("abc", "abc"), true
    assert.equal largereq("abc", "abd"), false

  it "should perform element-wise comparison for two matrices of the same size", ->
    assert.deepEqual largereq([1, 4, 6], [3, 4, 5]), [false, true, true]
    assert.deepEqual largereq([1, 4, 6], matrix([3, 4, 5])), matrix([false, true, true])

  it "should throw an error when comparing complex numbers", ->
    assert.throws (->
      largereq complex(1, 1), complex(1, 2)
    ), TypeError

    assert.throws (->
      largereq complex(2, 1), 3
    ), TypeError
    assert.throws (->
      largereq 3, complex(2, 4)
    ), TypeError
    assert.throws (->
      largereq erdos.bignumber(3), complex(2, 4)
    ), TypeError
    assert.throws (->
      largereq complex(2, 4), erdos.bignumber(3)
    ), TypeError

  it "should throw an error if comparing two matrices of different sizes", ->
    assert.throws ->
      largereq [1, 4, 6], [3, 4]
