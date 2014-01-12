assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

number = erdos.number
describe "number", ->
  it "should be 0 if called with no argument", ->
    approx.equal number(), 0

  it "should convert a boolean to a number", ->
    approx.equal number(true), 1
    approx.equal number(false), 0

  it "should convert a bignumber to a number", ->
    approx.equal number(erdos.bignumber(0.1)), 0.1
    approx.equal number(erdos.bignumber("1.3e500")), Infinity

  it "should accept a number as argument", ->
    approx.equal number(3), 3
    approx.equal number(-3), -3

  it "should parse the string if called with a valid string", ->
    approx.equal number("2.1e3"), 2100
    approx.equal number(" 2.1e-3 "), 0.0021
    approx.equal number(""), 0
    approx.equal number(" "), 0

  it "should throw an error if called with an invalid string", ->
    assert.throws (->
      number "2.3.4"
    ), SyntaxError
    assert.throws (->
      number "23a"
    ), SyntaxError

  it "should convert the elements of a matrix to numbers", ->
    assert.deepEqual number(erdos.matrix(["123", true])), new erdos.Matrix([123, 1])

  it "should convert the elements of an array to numbers", ->
    assert.deepEqual number(["123", true]), [123, 1]

  it "should throw an error if called with a wrong number of arguments", ->
    assert.throws (->
      number 1, 2
    ), SyntaxError
    assert.throws (->
      number 1, 2, 3
    ), SyntaxError

  it "should throw an error if called with a complex number", ->
    assert.throws (->
      number erdos.complex(2, 3)
    ), SyntaxError

  it "should throw an error if called with a unit", ->
    assert.throws (->
      number erdos.unit("5cm")
    ), SyntaxError
