assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

Selector = erdos.chaining.Selector

describe "select", ->
  it "should construct a selector", ->
    assert.ok erdos.select(45) instanceof Selector
    assert.ok erdos.select(erdos.complex(2, 3)) instanceof Selector
    assert.ok erdos.select() instanceof Selector
