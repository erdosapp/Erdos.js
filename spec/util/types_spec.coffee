# test types utils
assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

type = require("../../lib/util/types")

describe "types", ->
  it "type", ->
    assert.equal type(null), "null"
    assert.equal type(undefined), "undefined"
    assert.equal type(), "undefined"
    assert.equal type(false), "boolean"
    assert.equal type(true), "boolean"
    assert.equal type(2.3), "number"
    assert.equal type(Number(2.3)), "number"
    assert.equal type(new Number(2.3)), "number"
    assert.equal type("bla"), "string"
    assert.equal type(new String("bla")), "string"
    assert.equal type({}), "object"
    assert.equal type(new Object()), "object"
    assert.equal type([]), "array"
    assert.equal type(new Array()), "array"
    assert.equal type(new Date()), "date"
