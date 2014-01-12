assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
sin = erdos.sin
cos = erdos.cos
tan = erdos.tan

describe "tan", ->
  it "should return the tangent of a boolean", ->
    approx.equal tan(true), 1.55740772465490
    approx.equal tan(false), 0

  it "should return the tangent of a number", ->
    approx.equal tan(0), 0
    approx.equal tan(pi * 1 / 4), 1
    approx.equal tan(pi * 1 / 8), 0.414213562373095
    assert.ok tan(pi * 2 / 4) > 1e10
    approx.equal tan(pi * 3 / 4), -1
    approx.equal tan(pi * 4 / 4), 0
    approx.equal tan(pi * 5 / 4), 1
    assert.ok tan(pi * 6 / 4) > 1e10
    approx.equal tan(pi * 7 / 4), -1
    approx.equal tan(pi * 8 / 4), 0

  it "should return the tangent of a bignumber (downgrades to number)", ->
    approx.equal tan(erdos.bignumber(1)), 1.55740772465490

  it "should return the tangent of a complex number", ->
    re = 0.00376402564150425
    im = 1.00323862735360980
    approx.deepEqual tan(complex("2+3i")), complex(-re, im)
    approx.deepEqual tan(complex("2-3i")), complex(-re, -im)
    approx.deepEqual tan(complex("-2+3i")), complex(re, im)
    approx.deepEqual tan(complex("-2-3i")), complex(re, -im)
    approx.deepEqual tan(complex("i")), complex(0, 0.761594155955765)
    approx.deepEqual tan(complex("1")), complex(1.55740772465490, 0)
    approx.deepEqual tan(complex("1+i")), complex(0.271752585319512, 1.083923327338695)

  it "should return the tangent of an angle", ->
    approx.equal tan(unit(" 60deg")), erdos.sqrt(3)
    approx.equal tan(unit("-135deg")), 1

  it "should throw an error if called with an invalid unit", ->
    assert.throws ->
      tan unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      tan "string"

  tan123 = [1.557407724654902, -2.185039863261519, -0.142546543074278]
  it "should return the tan of each element of an array", ->
    approx.deepEqual tan([1, 2, 3]), tan123

  it "should return the tan of each element of a matrix", ->
    approx.deepEqual tan(matrix([1, 2, 3])), matrix(tan123)
