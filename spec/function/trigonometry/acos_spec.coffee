assert   = require("chai").assert
approx   = require("../../../tools/approx")
erdosjs  = require("../../../lib/erdos")
erdos    = erdosjs()

pi = erdos.pi
acos = erdos.acos
cos = erdos.cos
complex = erdos.complex
matrix = erdos.matrix
unit = erdos.unit

describe "acos", ->
	it "should return the arccos of a boolean", ->
	  approx.equal acos(true), 0
	  approx.equal acos(false), 0.5 * pi

	it "should return the arccos of a number", ->
	  approx.equal acos(-1) / pi, 1
	  approx.equal acos(-0.5) / pi, 2 / 3
	  approx.equal acos(0) / pi, 0.5
	  approx.equal acos(0.5) / pi, 1 / 3
	  approx.equal acos(1) / pi, 0

	it "should return the arccos of a bignumber (downgrades to number)", ->
	  approx.equal acos(erdos.bignumber(-1)), pi

	it "should be the inverse function of cos", ->
	  approx.equal acos(cos(-1)), 1
	  approx.equal acos(cos(0)), 0
	  approx.equal acos(cos(0.1)), 0.1
	  approx.equal acos(cos(0.5)), 0.5
	  approx.equal acos(cos(2)), 2

  it "should return the arccos of a complex number", ->

    approx.deepEqual acos(complex("2+3i")), complex(1.00014354247380, -1.98338702991654)
    approx.deepEqual acos(complex("2-3i")), complex(1.00014354247380, 1.98338702991654)
    approx.deepEqual acos(complex("-2+3i")), complex(2.14144911111600, -1.98338702991654)
    approx.deepEqual acos(complex("-2-3i")), complex(2.14144911111600, 1.98338702991654)
    approx.deepEqual acos(complex("i")), complex(1.570796326794897, -0.881373587019543)
    approx.deepEqual acos(complex("1")), complex(0, 0)
    approx.deepEqual acos(complex("1+i")), complex(0.904556894302381, -1.061275061905036)

	it "should throw an error if called with a unit", ->
	  assert.throws ->
	    acos unit("45deg")

	  assert.throws ->
	    acos unit("5 celsius")

	it "should throw an error if called with a string", ->
	  assert.throws ->
	    acos "string"

	it "should calculate the arccos element-wise for arrays and matrices", ->
	  
	  # note: the results of acos(2) and acos(3) differs in octave
	  # the next tests are verified with erdosematica
	  acos123 = [0, complex(0, 1.316957896924817), complex(0, 1.762747174039086)]
	  approx.deepEqual acos([1, 2, 3]), acos123
	  approx.deepEqual acos(matrix([1, 2, 3])), matrix(acos123)
	