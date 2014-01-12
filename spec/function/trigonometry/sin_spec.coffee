assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
sin = erdos.sin

describe "sin", ->
  it "should return the sine of a boolean", ->
    approx.equal sin(true), 0.841470984807897
    approx.equal sin(false), 0

  it "should return the sine of a number", ->
    approx.equal sin(0), 0
    approx.equal sin(pi * 1 / 4), 0.707106781186548
    approx.equal sin(pi * 1 / 8), 0.382683432365090
    approx.equal sin(pi * 2 / 4), 1
    approx.equal sin(pi * 3 / 4), 0.707106781186548
    approx.equal sin(pi * 4 / 4), 0
    approx.equal sin(pi * 5 / 4), -0.707106781186548
    approx.equal sin(pi * 6 / 4), -1
    approx.equal sin(pi * 7 / 4), -0.707106781186548
    approx.equal sin(pi * 8 / 4), 0
    approx.equal sin(pi / 4), erdos.sqrt(2) / 2

  it "should return the sine of a bignumber (downgrades to number)", ->
    approx.equal sin(erdos.bignumber(1)), 0.841470984807897

  it "should return the sine of a complex number", ->
    re = 9.15449914691143
    im = 4.16890695996656
    approx.deepEqual sin(complex("2+3i")), complex(re, -im)
    approx.deepEqual sin(complex("2-3i")), complex(re, im)
    approx.deepEqual sin(complex("-2+3i")), complex(-re, -im)
    approx.deepEqual sin(complex("-2-3i")), complex(-re, im)
    approx.deepEqual sin(complex("i")), complex(0, 1.175201193643801)
    approx.deepEqual sin(complex("1")), complex(0.841470984807897, 0)
    approx.deepEqual sin(complex("1+i")), complex(1.298457581415977, 0.634963914784736)

  it "should return the sine of an angle", ->
    approx.equal sin(unit("45deg")), 0.707106781186548
    approx.equal sin(unit("-45deg")), -0.707106781186548

  it "should throw an error if called with an invalid unit", ->
    assert.throws ->
      sin unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      sin "string"

  sin123 = [0.84147098480789, 0.909297426825682, 0.141120008059867]
  it "should return the sin of each element of an array", ->
    approx.deepEqual sin([1, 2, 3]), sin123

  it "should return the sin of each element of a matrix", ->
    approx.deepEqual sin(matrix([1, 2, 3])), matrix(sin123)
