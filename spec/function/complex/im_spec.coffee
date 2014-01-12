assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

describe "im", ->
  it "should return the imaginary part of a complex number", ->
    assert.equal erdos.im(erdos.complex(2, 3)), 3
    assert.equal erdos.im(erdos.complex(-2, -3)), -3
    assert.equal erdos.im(erdos.i), 1

  it "should return the imaginary part of a real number", ->
    assert.equal erdos.im(2), 0

  it "should return the imaginary part of a big number", ->
    assert.deepEqual erdos.im(erdos.bignumber(2)), erdos.bignumber(0)

  it "should return the imaginary part of a boolean", ->
    assert.equal erdos.im(true), 0
    assert.equal erdos.im(false), 0

  it "should return the imaginary part of a string", ->
    assert.equal erdos.im("string"), 0

  it "should return the imaginary part of a boolean", ->
    assert.equal erdos.im(true), 0
    assert.equal erdos.im(false), 0

  it "should return the imaginary part for each element in a matrix", ->
    assert.deepEqual erdos.im([2, erdos.complex("3-6i")]), [0, -6]
    assert.deepEqual erdos.im(erdos.matrix([2, erdos.complex("3-6i")])).valueOf(), [0, -6]
