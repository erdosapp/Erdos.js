assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "re", ->
  it "should return the real part of a complex number", ->
    assert.equal erdos.re(erdos.complex(2, 3)), 2
    assert.equal erdos.re(erdos.complex(-2, -3)), -2
    assert.equal erdos.re(erdos.i), 0

  it "should return the real part of a real number", ->
    assert.equal erdos.re(2), 2

  it "should return the real part of a big number", ->
    assert.deepEqual erdos.re(erdos.bignumber(2)), erdos.bignumber(2)

  it "should return the real part of a string", ->
    assert.equal erdos.re("string"), "string"

  it "should return the real part of a boolean", ->
    assert.equal erdos.re(true), true
    assert.equal erdos.re(false), false

  it "should return the real part for each element in a matrix", ->
    assert.deepEqual erdos.re([2, erdos.complex("3-6i")]), [2, 3]
    assert.deepEqual erdos.re(erdos.matrix([2, erdos.complex("3-6i")])).valueOf(), [2, 3]
