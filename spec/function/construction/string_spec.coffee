assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

string = erdos.string

describe "string", ->
  it "should be '' if called with no argument", ->
    assert.equal string(), ""

  it "should be 'true' if called with true, 'false' if called with false", ->
    assert.equal string(true), "true"
    assert.equal string(false), "false"

  it "should be the identity if called with a string", ->
    assert.equal string("hello"), "hello"
    assert.equal string(""), ""
    assert.equal string(" "), " "

  it "should convert the elements of an array to strings", ->
    assert.deepEqual string([[2, true], ["hi", null]]), [["2", "true"], ["hi", "null"]]

  it "should convert the elements of a matrix to strings", ->
    assert.deepEqual string(erdos.matrix([[2, true], ["hi", null]])), new erdos.Matrix([["2", "true"], ["hi", "null"]])

  it "should convert a number to string", ->
    assert.equal string(1 / 8), "0.125"
    assert.equal string(2.1e-3), "0.0021"
    assert.equal string(123456789), "1.23456789e+8"
    assert.equal string(2000000), "2e+6"

  it "should convert a bignumber to string", ->
    assert.equal string(erdos.bignumber("2.3e+500")), "2.3e+500"

  it "should convert a complex number to string", ->
    assert.equal string(erdos.complex(2, 3)), "2 + 3i"

  it "should convert a unit to string", ->
    assert.equal string(erdos.unit("5cm")), "50 mm"

  it "should throw an error if called with wrong number of arguments", ->
    assert.throws (->
      string 1, 2
    ), SyntaxError
    assert.throws (->
      string 1, 2, 3
    ), SyntaxError
