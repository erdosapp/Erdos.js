# test print
assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "print", ->
  it "should interpolate values in a template", ->
    assert.equal erdos.print("hello, $name!",
      name: "user"
    ), "hello, user!"

  it "should interpolate values from a nested object in a template", ->
    assert.equal erdos.print("hello, $name.first $name.last!",
      name:
        first: "first"
        last: "last"
    ), "hello, first last!"

  it "should round interpolate values to provided precision", ->
    assert.equal erdos.print("pi=$pi",
      pi: erdos.pi
    , 3), "pi=3.14"
