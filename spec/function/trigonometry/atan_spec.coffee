assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
atan = erdos.atan
tan = erdos.tan

describe "atan", ->
  it "should return the arctan of a boolean", ->
    approx.equal atan(true), 0.25 * pi
    approx.equal atan(false), 0

  it "should return the arctan of a number", ->
    approx.equal atan(-1) / pi, -0.25
    approx.equal atan(-0.5) / pi, -0.147583617650433
    approx.equal atan(0) / pi, 0
    approx.equal atan(0.5) / pi, 0.147583617650433
    approx.equal atan(1) / pi, 0.25

  it "should return the arctan of a bignumber (downgrades to number)", ->
    approx.equal atan(erdos.bignumber(1)), pi / 4

  it "should be the inverse function of tan", ->
    approx.equal atan(tan(-1)), -1
    approx.equal atan(tan(0)), 0
    approx.equal atan(tan(0.1)), 0.1
    approx.equal atan(tan(0.5)), 0.5
    approx.equal atan(tan(2)), -1.14159265358979

  it "should return the arctan of a complex number", ->
    re = 1.409921049596575
    im = 0.229072682968539
    approx.deepEqual atan(complex("2+3i")), complex(re, im)
    approx.deepEqual atan(complex("2-3i")), complex(re, -im)
    approx.deepEqual atan(complex("-2+3i")), complex(-re, im)
    approx.deepEqual atan(complex("-2-3i")), complex(-re, -im)
    approx.deepEqual atan(complex("i")), complex(NaN, NaN) # TODO: should return NaN + Infi instead
    approx.deepEqual atan(complex("1")), complex(0.785398163397448, 0)
    approx.deepEqual atan(complex("1+i")), complex(1.017221967897851, 0.402359478108525)

  it "should throw an error if called with a unit", ->
    assert.throws ->
      atan unit("45deg")

    assert.throws ->
      atan unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      atan "string"

  it "should calculate the arctan element-wise for arrays and matrices", ->    
    # matrix, array, range
    atan123 = [0.785398163397448, 1.107148717794090, 1.249045772398254]
    approx.deepEqual atan([1, 2, 3]), atan123
    approx.deepEqual atan(matrix([1, 2, 3])), matrix(atan123)
