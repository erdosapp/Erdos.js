assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

conj = erdos.conj

describe "conj", ->
  it "should compute the conjugate of a boolean", ->
    assert.equal conj(true), true
    assert.equal conj(false), false

  it "should compute the conjugate of a number", ->
    assert.equal conj(1), 1
    assert.equal conj(2), 2
    assert.equal conj(0), 0
    assert.equal conj(-2), -2

  it "should compute the conjugate of a bignumber", ->
    assert.deepEqual conj(erdos.bignumber(2)), erdos.bignumber(2)

  it "should calculate the conjugate of a complex number correctly", ->
    assert.equal conj(erdos.complex("2 + 3i")).toString(), "2 - 3i"
    assert.equal conj(123).toString(), "123"
    assert.equal conj(erdos.complex("2 - 3i")).toString(), "2 + 3i"
    assert.equal conj(erdos.complex("2")).toString(), "2"
    assert.equal conj(erdos.complex("-4i")).toString(), "4i"
    assert.equal conj(erdos.i).toString(), "-i"

  it "should calculate the conjugate for each element in a matrix", ->
    assert.equal erdos.format(conj([erdos.complex("2+3i"), erdos.complex("3-4i")])), "[2 - 3i, 3 + 4i]"
    assert.equal conj(erdos.matrix([erdos.complex("2+3i"), erdos.complex("3-4i")])).toString(), "[2 - 3i, 3 + 4i]"

  it "should be identity if used with a string", ->
    assert.equal conj("string"), "string"

  it "should be identity if used with a unit", ->
    assert.deepEqual conj(erdos.unit("5cm")), erdos.unit("5cm")
