# test boolean utils
assert   = require("chai").assert
approx   = require("../../tools/approx")
erdosjs  = require("../../lib/erdos")
erdos    = erdosjs()

boolean = require("../../lib/util/boolean")

describe "boolean", ->
  it "isBoolean", ->
    assert.equal boolean.isBoolean(true), true
    assert.equal boolean.isBoolean(false), true
    assert.equal boolean.isBoolean(new Boolean(true)), true
    assert.equal boolean.isBoolean(new Boolean(false)), true
    assert.equal boolean.isBoolean("hi"), false
    assert.equal boolean.isBoolean(23), false
    assert.equal boolean.isBoolean([]), false
    assert.equal boolean.isBoolean({}), false
    assert.equal boolean.isBoolean(new Date()), false
