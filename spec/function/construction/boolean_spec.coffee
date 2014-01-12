assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

bool = erdos["boolean"]

describe "boolean", ->
  it "should be the identity with a boolean", ->
    assert.equal bool(true), true
    assert.equal bool(false), false

  it "should convert a number into a boolean", ->
    assert.equal bool(-2), true
    assert.equal bool(-1), true
    assert.equal bool(0), false
    assert.equal bool(1), true
    assert.equal bool(2), true

  it "should convert a bignumber into a boolean", ->
    assert.equal bool(erdos.bignumber(-2)), true
    assert.equal bool(erdos.bignumber(-1)), true
    assert.equal bool(erdos.bignumber(0)), false
    assert.equal bool(erdos.bignumber(1)), true
    assert.equal bool(erdos.bignumber(2)), true

  it "should convert the elements of a matrix or array to booleans", ->
    assert.deepEqual bool(erdos.matrix([1, 0, 1, 1])), new erdos.Matrix([true, false, true, true])
    assert.deepEqual bool([1, 0, 1, 1]), [true, false, true, true]

  it "should convert a string into a boolean", ->
    assert.equal bool("2"), true
    assert.equal bool(" 4e2 "), true
    assert.equal bool(" -4e2 "), true
    assert.equal bool("0"), false
    assert.equal bool(" 0 "), false

  it "should throw an error if the string is not a valid number", ->
    assert.throws (->
      bool ""
    ), SyntaxError
    assert.throws (->
      bool "23a"
    ), SyntaxError

  it "should throw an error if there's a wrong number of arguments", ->
    assert.throws (->
      bool 1, 2
    ), SyntaxError
    assert.throws (->
      bool 1, 2, 3
    ), SyntaxError

  it "should throw an error if used with a complex", ->
    assert.throws (->
      bool erdos.complex(2, 3)
    ), SyntaxError

  it "should throw an error if used with a unit", ->
    assert.throws (->
      bool erdos.unit("5cm")
    ), SyntaxError
