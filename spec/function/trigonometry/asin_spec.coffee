assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit
asin = erdos.asin
sin = erdos.sin

describe "asin", ->
  it "should return the arcsin of a boolean", ->
    approx.equal asin(true), 0.5 * pi
    approx.equal asin(false), 0

  it "should return the arcsin of a number", ->
    approx.equal asin(-1) / pi, -0.5
    approx.equal asin(-0.5) / pi, -1 / 6
    approx.equal asin(0) / pi, 0
    approx.equal asin(0.5) / pi, 1 / 6
    approx.equal asin(1) / pi, 0.5

  it "should return the arcsin of a bignumber (downgrades to number)", ->
    approx.equal asin(erdos.bignumber(-1)), -pi / 2

  it "should be the inverse function of sin", ->
    approx.equal asin(sin(-1)), -1
    approx.equal asin(sin(0)), 0
    approx.equal asin(sin(0.1)), 0.1
    approx.equal asin(sin(0.5)), 0.5
    approx.equal asin(sin(2)), 1.14159265358979

  it "should return the arcsin of a complex number", ->
    re = 0.570652784321099
    im = 1.983387029916536
    approx.deepEqual asin(complex("2+3i")), complex(re, im)
    approx.deepEqual asin(complex("2-3i")), complex(re, -im)
    approx.deepEqual asin(complex("-2+3i")), complex(-re, im)
    approx.deepEqual asin(complex("-2-3i")), complex(-re, -im)
    approx.deepEqual asin(complex("i")), complex(0, 0.881373587019543)
    approx.deepEqual asin(complex("1")), complex(1.57079632679490, 0)
    approx.deepEqual asin(complex("1+i")), complex(0.666239432492515, 1.061275061905036)

  it "should throw an error if called with a unit", ->
    assert.throws ->
      asin unit("45deg")

    assert.throws ->
      asin unit("5 celsius")

  it "should throw an error if called with a string", ->
    assert.throws ->
      asin "string"

  it "should calculate the arcsin element-wise for arrays and matrices", ->
    
    # note: the results of asin(2) and asin(3) differs in octave
    # the next tests are verified with erdosematica
    asin123 = [1.57079632679490, complex(1.57079632679490, -1.31695789692482), complex(1.57079632679490, -1.76274717403909)]
    approx.deepEqual asin([1, 2, 3]), asin123
    approx.deepEqual asin(matrix([1, 2, 3])), matrix(asin123)
