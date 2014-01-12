assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

arg = erdos.arg

describe "arg", ->
  it "should compute the argument of a boolean", ->
    assert.equal arg(true), 0
    assert.equal arg(false), 0

  it "should compute the argument of a number", ->
    assert.equal arg(1), 0
    assert.equal arg(2), 0
    assert.equal arg(0), 0
    approx.equal arg(-2), 3.141592653589793

  it "should compute the argument of a bignumber (downgrades to number)", ->
    assert.equal arg(erdos.bignumber(1)), 0

  it "should compute the argument of a complex number correctly", ->
    assert.equal arg(erdos.complex("0")) / erdos.pi, 0
    assert.equal arg(erdos.complex("1 + 0i")) / erdos.pi, 0
    assert.equal arg(erdos.complex("1 + i")) / erdos.pi, 0.25
    assert.equal arg(erdos.complex("0 + i")) / erdos.pi, 0.5
    assert.equal arg(erdos.complex("-1 + i")) / erdos.pi, 0.75
    assert.equal arg(erdos.complex("-1 + 0i")) / erdos.pi, 1
    assert.equal arg(erdos.complex("-1 - i")) / erdos.pi, -0.75
    assert.equal arg(erdos.complex("0 - i")) / erdos.pi, -0.5
    assert.equal arg(erdos.complex("1 - i")) / erdos.pi, -0.25
    assert.equal arg(erdos.i) / erdos.pi, 0.5

  it "should calculate the argument for each element in a matrix", ->
    assert.deepEqual erdos.divide(arg([erdos.i, erdos.unary(erdos.i), erdos.add(1, erdos.i)]), erdos.pi), [0.5, -0.5, 0.25]
    assert.deepEqual erdos.matrix(erdos.divide(arg([erdos.i, erdos.unary(erdos.i), erdos.add(1, erdos.i)]), erdos.pi)).valueOf(), [0.5, -0.5, 0.25]

  it "should compute the argument of a real number correctly", ->
    assert.equal arg(2) / erdos.pi, 0
    assert.equal arg(-2) / erdos.pi, 1

  it "should throw an error if used with a string", ->
    assert.throws ->
      arg "string"

  it "should throw an error if used with a unit", ->
    assert.throws ->
      arg erdos.unit("5cm")
