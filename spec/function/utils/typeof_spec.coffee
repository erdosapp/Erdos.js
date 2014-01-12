# test typeoff
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "typeof", ->
  it "should return number type for a number", ->
    assert.equal erdos.typeof(2), "number"
    assert.equal erdos.typeof(new Number(2)), "number"

  it "should return bignumber type for a bignumber", ->
    assert.equal erdos.typeof(erdos.bignumber(0.1)), "bignumber"
    assert.equal erdos.typeof(new erdos.BigNumber("0.2")), "bignumber"

  it "should return string type for a string", ->
    assert.equal erdos.typeof("hello there"), "string"
    assert.equal erdos.typeof(new String("hello there")), "string"

  it "should return complex type for a complex number", ->
    assert.equal erdos.typeof(erdos.complex(2, 3)), "complex"

  it "should return array type for an array", ->
    assert.equal erdos.typeof([1, 2, 3]), "array"
    assert.equal erdos.typeof(new Array()), "array"

  it "should return matrix type for a matrix", ->
    assert.equal erdos.typeof(erdos.matrix()), "matrix"

  it "should return unit type for a unit", ->
    assert.equal erdos.typeof(erdos.unit("5cm")), "unit"

  it "should return boolean type for a boolean", ->
    assert.equal erdos.typeof(true), "boolean"
    assert.equal erdos.typeof(false), "boolean"
    assert.equal erdos.typeof(new Boolean(true)), "boolean"

  it "should return null type for null", ->
    assert.equal erdos.typeof(null), "null"

  it "should return undefined type for undefined", ->
    assert.equal erdos.typeof(undefined), "undefined"

  it "should return date type for a Date", ->
    assert.equal erdos.typeof(new Date()), "date"

  it "should return function type for a function", ->
    assert.equal erdos.typeof(->
    ), "function"
    assert.equal erdos.typeof(new Function()), "function"

  it "should return function type for a selector", ->
    assert.equal erdos.typeof(erdos.select(3)), "selector"

  it "should return object type for an object", ->
    assert.equal erdos.typeof({}), "object"
    assert.equal erdos.typeof(new Object()), "object"

  it "should throw an error if called with a wrong number of arguments", ->
    assert.throws ->
      erdos.typeof()

    assert.throws ->
      erdos.typeof 1, 2
